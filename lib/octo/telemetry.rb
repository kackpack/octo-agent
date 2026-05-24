# frozen_string_literal: true

require "json"
require "digest"
require "socket"
require_relative "platform_http_client"

module Octo
  # Telemetry — lightweight, anonymous usage reporting for the Octo gem.
  #
  # Privacy-first design (modeled after Homebrew's opt-out analytics):
  #   - Anonymous device identification (SHA256 of hostname + user + platform)
  #   - No IP collection, no user-input collection, no file paths
  #   - Fire-and-forget (background thread, no retry, silent failure)
  #   - Opt-out via OCTO_TELEMETRY=0 environment variable
  #
  # Event types:
  #   startup — sent on every CLI startup; server deduplicates by device_hash for unique devices
  #   task    — sent after each agent.run completes (tracks usage & active users)
  #
  # Platform endpoints:
  #   POST /api/v1/telemetry/startup
  #   POST /api/v1/telemetry/task
  module Telemetry
    class << self
      # Called on every CLI startup (agent and server mode).
      # No local dedup — the server deduplicates by device_hash for unique
      # device counting, while raw event count tracks total startup volume.
      def startup!
        return unless enabled?

        payload = {
          device_id:    device_id,
          version:      Octo::VERSION,
          os:           RbConfig::CONFIG["host_os"],
          ruby_version: RUBY_VERSION
        }

        fire_and_forget("/api/v1/telemetry/startup", payload)
      end

      # Called after every agent.run completes (CLI and server mode).
      # Tracks usage activity and daily task volume.
      # No client-side dedup — the server keeps every event for task counting,
      # and derives DAU from distinct devices per day.
      def task!
        return unless enabled?

        payload = {
          device_id: device_id,
          version:   Octo::VERSION
        }

        fire_and_forget("/api/v1/telemetry/task", payload)
      end

      # ── private helpers ────────────────────────────────────────────────

      private def enabled?
        return false if ENV["OCTO_TELEMETRY"] == "0" || ENV["OCTO_TELEMETRY"] == "false"
        true
      end

      private def device_id
        @device_id ||= Digest::SHA256.hexdigest(
          "#{Socket.gethostname}:#{ENV["USER"] || ENV["USERNAME"]}:#{RbConfig::CONFIG["host_os"]}"
        )
      end

      # Send a POST to the telemetry endpoint in a background thread.
      # Fire-and-forget: no retry, no error surfacing, no blocking.
      #
      # Uses PlatformHttpClient for unified HTTP handling (retry + failover
      # happen in the background thread, so they don't block startup).
      private def fire_and_forget(path, payload)
        Thread.new do
          begin
            platform_client.post(path, payload)
          rescue StandardError
            # Silent failure — telemetry is best-effort
            nil
          end
        end
      end

      # Lazy-initialised PlatformHttpClient. Host selection is automatic:
      # OCTO_LICENSE_SERVER env var when set, otherwise primary + fallback.
      private def platform_client
        @platform_client ||= Octo::PlatformHttpClient.new
      end
    end
  end
end
