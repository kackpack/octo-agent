# frozen_string_literal: true

ENV["OCTO_TEST"] = "1"

require "octo"
require "tmpdir"
require "fileutils"
require "climate_control"
require_relative "support/test_helpers"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  # Exclude smoke tests from the default test run — they make real network requests.
  # Run explicitly with: bundle exec rspec spec/integration/ --tag smoke
  config.filter_run_excluding :smoke
end
