# frozen_string_literal: true

module Octo
  module Tools
    class Base
      class << self
        attr_accessor :tool_name, :tool_description, :tool_parameters, :tool_category
      end

      def name
        self.class.tool_name
      end

      def description
        self.class.tool_description
      end

      def parameters
        self.class.tool_parameters
      end

      def category
        self.class.tool_category || "general"
      end

      # Execute the tool - must be implemented by subclasses
      def execute(**_args)
        raise NotImplementedError, "#{self.class.name} must implement #execute"
      end

      # Expand ~ to home directory only if path starts with ~
      # Relative paths are resolved against working_dir if provided
      # @param path [String, nil] The path to expand
      # @param working_dir [String, nil] The working directory to resolve relative paths against
      # @return [String, nil] The expanded path, or original if no ~ present
      private def expand_path(path, working_dir: nil)
        return path if path.nil? || path.strip.empty?
        return File.expand_path(path) if path.start_with?("~")
        return File.expand_path(path, working_dir) if working_dir && !path.start_with?("/")
        # Always resolve relative paths to absolute (even without working_dir), so callers
        # never receive a bare "." that resolves against the process cwd unexpectedly.
        return File.expand_path(path) unless path.start_with?("/")

        path
      end

      # Format tool call for display - can be overridden by subclasses
      # @param args [Hash] The arguments passed to the tool
      # @return [String] Formatted call description (e.g., "Read(file.rb)")
      def format_call(args)
        "#{name}(...)"
      end

      # Format tool result for display - can be overridden by subclasses
      # @param result [Object] The result returned by execute
      # @return [String] Formatted result summary (e.g., "Read 150 lines")
      def format_result(result)
        if result.is_a?(Hash) && result[:message]
          result[:message]
        elsif result.is_a?(String)
          result.length > 100 ? "#{result[0..100]}..." : result
        else
          "Done"
        end
      end

      # Format tool result as a structured hash for rich UI rendering.
      # When a tool implements this, the WebUI can render a beautiful
      # card instead of a plain text blob.
      #
      # @param result [Object] The result returned by execute
      # @return [Hash, nil] A hash with :type and tool-specific fields,
      #   or nil to fall back to plain-text format_result.
      #
      # Supported types and their schemas:
      #
      #   { type: "file_read", path:, lines_read:, total_lines:,
      #     truncated:, content_preview:, language: }
      #
      #   { type: "file_list", path:, entries:[{name, is_dir}], total }
      #
      #   { type: "search", pattern:, path:, matches:[{file, line_no, line, context?}],
      #     total_matches, files_with_matches, truncated }
      #
      #   { type: "terminal", command:, exit_code:, output_preview:,
      #     output_truncated:, full_output_file? }
      #
      #   { type: "web_fetch", url:, title?, content_preview: }
      #
      #   { type: "web_search", query:, results:[{title, url, snippet}] }
      #
      #   { type: "edit", path:, operation:, occurrences: }
      #
      #   { type: "write", path:, is_new_file:, size_bytes: }
      #
      #   { type: "todo", action:, todos:[{id, task, status}] }
      #
      #   { type: "browser", action:, url?, title?, content_preview? }
      #
      #   { type: "generic", title:, content:, status: "ok|error|warning" }
      def format_result_for_ui(result)
        nil
      end

      # Convert to OpenAI function calling format
      def to_function_definition
        {
          type: "function",
          function: {
            name: name,
            description: description,
            parameters: parameters
          }
        }
      end
    end
  end
end
