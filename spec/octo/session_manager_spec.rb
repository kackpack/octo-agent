# frozen_string_literal: true

require "tmpdir"
require "fileutils"
require "json"

RSpec.describe Octo::SessionManager do
  let(:temp_dir) { Dir.mktmpdir("octo_sm_spec") }
  subject(:manager) { described_class.new(sessions_dir: temp_dir) }

  after { FileUtils.rm_rf(temp_dir) if Dir.exist?(temp_dir) }

  def persist_session(session_id: "abcdef1234567890", created_at: "2025-01-02T03:04:05+00:00", updated_at: nil, messages: [])
    data = {
      session_id: session_id,
      created_at: created_at,
      updated_at: updated_at || created_at,
      messages: messages
    }
    manager.save(data)
    data
  end

  describe "#append_message_log" do
    it "creates a .jsonl file with one line per message" do
      msgs = [
        { role: "user", content: "hello" },
        { role: "assistant", content: "hi" }
      ]
      manager.append_message_log("sess-1", msgs)

      path = File.join(temp_dir, "sess-1.jsonl")
      expect(File.exist?(path)).to be true

      lines = File.readlines(path).map { |l| JSON.parse(l, symbolize_names: true) }
      expect(lines.size).to eq(2)
      expect(lines[0][:msg]).to eq({ role: "user", content: "hello" })
      expect(lines[1][:msg]).to eq({ role: "assistant", content: "hi" })
      expect(lines[0][:t]).to be_a(Float)
    end

    it "appends to an existing .jsonl file" do
      manager.append_message_log("sess-1", [{ role: "user", content: "a" }])
      manager.append_message_log("sess-1", [{ role: "assistant", content: "b" }])

      lines = File.readlines(File.join(temp_dir, "sess-1.jsonl"))
      expect(lines.size).to eq(2)
    end

    it "is a no-op for empty messages" do
      manager.append_message_log("sess-1", [])
      expect(Dir.glob(File.join(temp_dir, "*.jsonl"))).to be_empty
    end

    it "is a no-op for nil messages" do
      manager.append_message_log("sess-1", nil)
      expect(Dir.glob(File.join(temp_dir, "*.jsonl"))).to be_empty
    end
  end

  describe "#read_message_log" do
    it "returns messages in order" do
      manager.append_message_log("sess-1", [
        { role: "user", content: "a" },
        { role: "assistant", content: "b" }
      ])

      result = manager.read_message_log("sess-1")
      expect(result.map { |m| m[:role] }).to eq(["user", "assistant"])
    end

    it "returns empty array when file does not exist" do
      expect(manager.read_message_log("missing")).to eq([])
    end

    it "skips malformed lines and returns the rest" do
      path = File.join(temp_dir, "sess-1.jsonl")
      File.write(path, "{\"msg\":{\"role\":\"user\"}}\nthis is broken\n{\"msg\":{\"role\":\"assistant\"}}\n")

      result = manager.read_message_log("sess-1")
      expect(result.size).to eq(2)
      expect(result.map { |m| m[:role] }).to eq(["user", "assistant"])
    end
  end

  describe "#delete_message_log" do
    it "removes the .jsonl file" do
      manager.append_message_log("sess-1", [{ role: "user", content: "a" }])
      manager.delete_message_log("sess-1")

      expect(File.exist?(File.join(temp_dir, "sess-1.jsonl"))).to be false
    end

    it "is a no-op when file does not exist" do
      expect { manager.delete_message_log("missing") }.not_to raise_error
    end
  end

  describe "#recover_jsonl_sessions" do
    it "merges orphaned jsonl messages into the matching session" do
      persist_session(
        session_id: "sess-1",
        messages: [{ role: "user", content: "original" }]
      )
      manager.append_message_log("sess-1", [
        { role: "assistant", content: "crashed mid-run" },
        { role: "tool", content: "result" }
      ])

      recovered = manager.recover_jsonl_sessions
      expect(recovered).to eq(1)

      session = manager.load("sess-1")
      expect(session[:messages].size).to eq(3)
      expect(session[:messages].last[:role]).to eq("tool")

      expect(File.exist?(File.join(temp_dir, "sess-1.jsonl"))).to be false
    end

    it "deduplicates overlapping messages" do
      persist_session(
        session_id: "sess-1",
        messages: [
          { role: "user", content: "a" },
          { role: "assistant", content: "b" }
        ]
      )
      manager.append_message_log("sess-1", [
        { role: "assistant", content: "b" },
        { role: "tool", content: "c" }
      ])

      manager.recover_jsonl_sessions
      session = manager.load("sess-1")
      expect(session[:messages].size).to eq(3)
      expect(session[:messages].map { |m| m[:role] }).to eq(["user", "assistant", "tool"])
    end

    it "skips jsonl files with no matching session" do
      manager.append_message_log("orphan", [{ role: "user", content: "x" }])

      expect(manager.recover_jsonl_sessions).to eq(0)
      # jsonl is left untouched when session is missing
      expect(File.exist?(File.join(temp_dir, "orphan.jsonl"))).to be true
    end

    it "returns 0 when there are no jsonl files" do
      expect(manager.recover_jsonl_sessions).to eq(0)
    end

    it "updates the session updated_at timestamp" do
      old_time = "2025-01-01T00:00:00+00:00"
      persist_session(session_id: "sess-1", created_at: old_time, updated_at: old_time)
      manager.append_message_log("sess-1", [{ role: "assistant", content: "x" }])

      manager.recover_jsonl_sessions
      session = manager.load("sess-1")
      expect(session[:updated_at]).not_to eq(old_time)
    end
  end

  describe "#merge_without_duplicates (private)" do
    it "is tested via recover_jsonl_sessions overlap case" do
      # covered above
    end
  end
end
