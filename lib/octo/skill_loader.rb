# frozen_string_literal: true

require "pathname"
require "fileutils"
require "octo"

module Octo
  # Loader and registry for skills.
  # Discovers skills from multiple locations and provides lookup functionality.
  class SkillLoader
    # Skill discovery locations (in priority order: lower index = lower priority)
    LOCATIONS = [
      :default,            # gem's built-in default skills (lowest priority)
      :global_octo,      # ~/.octo/skills/
      :project_octo      # .octo/skills/ (highest priority)
    ].freeze

    # Initialize the skill loader and automatically load all skills
    # @param working_dir [String, nil] Current working directory for project-level discovery.
    #   When nil, project-level skills (.octo/skills/) are not loaded,
    #   making the loader project-agnostic (used by WebUI server).
    def initialize(working_dir:)
      @working_dir  = working_dir
      @skills = {}            # Map identifier -> Skill
      @skills_by_command = {} # Map slash_command -> Skill
      @errors = []            # Store loading errors
      @loaded_from = {}       # Track which location each skill was loaded from

      load_all
    end

    # Load all skills from configured locations
    # Clears previously loaded skills before loading to ensure idempotency
    # @return [Array<Skill>] Loaded skills
    def load_all
      # Clear existing skills to ensure idempotent reloading
      clear

      load_default_skills
      load_global_octo_skills
      
      # Only load project-level skills when working_dir is explicitly provided.
      # When nil (e.g. WebUI server mode), skip project skills to keep the loader
      # project-agnostic and only expose global skills.
      if @working_dir
        load_project_octo_skills
      end

      all_skills
    end

    # Load skills from ~/.octo/skills/ (user global)
    # @return [Array<Skill>]
    def load_global_octo_skills
      global_octo_dir = Pathname.new(ENV.fetch("HOME", "~")).join(".octo", "skills")
      load_skills_from_directory(global_octo_dir, :global_octo)
    end

    # Load skills from .octo/skills/ (project-level, highest priority)
    # @return [Array<Skill>]
    def load_project_octo_skills
      project_octo_dir = Pathname.new(@working_dir).join(".octo", "skills")
      load_skills_from_directory(project_octo_dir, :project_octo)
    end

    # Get all loaded skills
    # @return [Array<Skill>]
    def all_skills
      @skills.values
    end

    # Get a skill by its identifier
    # @param identifier [String] Skill name or directory name
    # @return [Skill, nil]
    def [](identifier)
      @skills[identifier]
    end

    # Find a skill by its slash command
    # @param command [String] e.g., "/explain-code"
    # @return [Skill, nil]
    def find_by_command(command)
      @skills_by_command[command]
    end

    # Find a skill by its name (identifier)
    # @param name [String] Skill identifier (e.g., "code-explorer", "pptx")
    # @return [Skill, nil]
    def find_by_name(name)
      @skills[name]
    end

    # Get skills that can be invoked by user
    # @return [Array<Skill>]
    def user_invocable_skills
      all_skills.select(&:user_invocable?)
    end

    # Get the count of loaded skills
    # @return [Integer]
    def count
      @skills.size
    end

    # Get loading errors
    # @return [Array<String>]
    def errors
      @errors.dup
    end

    # Get the source location for each loaded skill
    # @return [Hash{String => Symbol}] Map of skill identifier to source location
    def loaded_from
      @loaded_from.dup
    end

    # Clear loaded skills and errors
    def clear
      @skills.clear
      @skills_by_command.clear
      @loaded_from.clear
      @errors.clear
    end

    # Create a new skill directory and SKILL.md file
    # @param name [String] Skill name (will be used for directory and slash command)
    # @param content [String] Skill content (SKILL.md body)
    # @param description [String] Skill description
    # @param location [Symbol] Where to create: :global or :project
    # @return [Skill] The created skill
    def create_skill(name, content, description = nil, location: :global)
      # Validate name
      unless name.match?(/^[a-z0-9][a-z0-9-]*$/)
        raise Octo::AgentError,
          "Invalid skill name '#{name}'. Use lowercase letters, numbers, and hyphens only."
      end

      # Determine directory path
      skill_dir = case location
      when :global
        Pathname.new(ENV.fetch("HOME", "~")).join(".octo", "skills", name)
      when :project
        Pathname.new(@working_dir).join(".octo", "skills", name)
      else
        raise Octo::AgentError, "Unknown skill location: #{location}"
      end

      # Create directory if it doesn't exist
      FileUtils.mkdir_p(skill_dir)

      # Build frontmatter
      frontmatter = { "name" => name, "description" => description }

      # Write SKILL.md
      skill_content = build_skill_content(frontmatter, content)
      skill_file = skill_dir.join("SKILL.md")
      skill_file.write(skill_content)

      # Load the newly created skill
      source_type = case location
      when :global then :global_octo
      when :project then :project_octo
      else :global_octo
      end
      load_single_skill(skill_dir, skill_dir, name, source_type)
    end

    # Toggle a skill's disable-model-invocation field in its SKILL.md.
    # System skills (source: :default) cannot be toggled — raises AgentError.
    # @param name [String] Skill identifier
    # @param enabled [Boolean] true = enable, false = disable
    # @return [Skill] The reloaded skill
    def toggle_skill(name, enabled:)
      skill = @skills[name]
      raise Octo::AgentError, "Skill not found: #{name}" unless skill
      raise Octo::AgentError, "Cannot toggle system skill: #{name}" if @loaded_from[name] == :default

      skill_file = skill.directory.join("SKILL.md")
      fm = (skill.frontmatter || {}).dup

      if enabled
        fm["disable-model-invocation"] = false
      else
        fm["disable-model-invocation"] = true
      end

      skill_file.write(build_skill_content(fm, skill.content))

      # Reload into registry
      reloaded = Skill.new(skill.directory, source_path: skill.source_path)
      @skills[reloaded.identifier] = reloaded
      @skills_by_command[reloaded.slash_command] = reloaded
      reloaded
    end

    # Delete a skill
    # @param name [String] Skill name
    # @return [Boolean] True if deleted, false if not found
    def delete_skill(name)
      skill = @skills[name]
      return false unless skill

      # Remove from registry
      @skills.delete(name)
      @skills_by_command.delete(skill.slash_command)

      # Delete directory
      FileUtils.rm_rf(skill.directory)

      true
    end


    def load_skills_from_directory(dir, source_type)
      return [] unless dir.exist?

      source_path = case source_type
      when :global_octo
        Pathname.new(ENV.fetch("HOME", "~")).join(".octo")
      when :project_octo
        Pathname.new(@working_dir)
      else
        dir
      end

      skills = []
      dir.children.select(&:directory?).each do |entry|
        if entry.join("SKILL.md").exist?
          # Direct skill directory
          skill = load_single_skill(entry, source_path, entry.basename.to_s, source_type)
          skills << skill if skill
        else
          # Treat as a category directory — scan one level deeper for skills.
          # This allows grouping skills under ~/.octo/skills/<category>/<skill>/SKILL.md
          # (e.g. openclaw-imports/my-skill/SKILL.md) without changing the loader contract.
          entry.children.select(&:directory?).each do |skill_dir|
            next unless skill_dir.join("SKILL.md").exist?

            skill = load_single_skill(skill_dir, source_path, skill_dir.basename.to_s, source_type)
            skills << skill if skill
          end
        end
      end
      skills
    end

    private def load_single_skill(skill_dir, source_path, skill_name, source_type)
      skill = Skill.new(skill_dir, source_path: source_path)
      register_skill(skill, source: source_type)
      skill
    rescue Octo::AgentError => e
      @errors << "Error loading skill '#{skill_name}' from #{skill_dir}: #{e.message}"
      nil
    rescue StandardError => e
      @errors << "Unexpected error loading skill '#{skill_name}' from #{skill_dir}: #{e.message}"
      nil
    end

    # Register a skill into the internal lookup tables.
    # - Always adds to @skills (by identifier) so the skill is discoverable in the UI.
    # - Skips @skills_by_command registration when the skill is invalid (no valid slug
    #   to form a slash command from).
    # @param skill [Skill]
    # @param source [Symbol] one of :default, :global_octo, :project_octo
    # @return [Skill, nil] nil when the skill was rejected (duplicate/limit)
    private def register_skill(skill, source:)
      id             = skill.identifier
      priority_order = %i[default global_octo project_octo]

      # --- duplicate check ---
      if (existing = @skills[id])
        existing_source = @loaded_from[id]
        if priority_order.index(source) > priority_order.index(existing_source)
          # Incoming skill has higher priority — evict the existing one
          @skills.delete(existing.identifier)
          @skills_by_command.delete(existing.slash_command)
          @loaded_from.delete(existing.identifier)
        else
          @errors << "Skipping duplicate skill '#{id}' (lower priority) from #{skill.directory}"
          return nil
        end
      end

      # Register in main skills hash
      @skills[id]        = skill
      @loaded_from[id]   = source
      skill.source       = source

      # Invalid skills have no usable slug — skip slash command registration but
      # still keep them in @skills so they appear (greyed-out) in the UI.
      unless skill.invalid?
        @skills_by_command[skill.slash_command] = skill
      end

      skill
    end

    def build_skill_content(frontmatter, content)
      yaml = frontmatter
        .reject { |_, v| v.nil? || v.to_s.empty? }
        .to_yaml(line_width: 80)

      "---\n#{yaml}---\n\n#{content}"
    end

    # Load default skills from gem's default_skills directory
    private def load_default_skills
      # Get the gem's lib directory
      gem_lib_dir = File.expand_path("../", __dir__)
      default_skills_dir = File.join(gem_lib_dir, "octo", "default_skills")

      return unless Dir.exist?(default_skills_dir)

      # Load each skill directory
      Dir.glob(File.join(default_skills_dir, "*/SKILL.md")).each do |skill_file|
        skill_dir = File.dirname(skill_file)
        skill_name = File.basename(skill_dir)

        begin
          skill = Skill.new(Pathname.new(skill_dir))
          register_skill(skill, source: :default)
        rescue StandardError => e
          @errors << "Failed to load default skill #{skill_name}: #{e.message}"
        end
      end
    end
  end
end
