require 'spec_helper'

describe Cbratest do
  before do
    @puts = []
    allow_any_instance_of(Cbratest::Runner).to receive(:output) do |obj, arg|
      @puts << arg
    end
  end

  it "outputs all affected components in verbose mode" do
    start_path = File.expand_path(File.join(__FILE__, "..", "..", "..", "spec", "examples", "letters"))
    options = { display: "verbose" }

    Cbratest::Runner.new(options).run(File.join(start_path, 'A'))
    expect(@puts).to eq(
      [
        "All components",
        [
          "B    #{start_path}/B",
          "C    #{start_path}/C",
          "D    #{start_path}/D",
          "E1   #{start_path}/E1",
          "E2   #{start_path}/E2",
          "F    #{start_path}/F",
          "A    #{start_path}/A"
        ],
        "\nChanges since last commit on current branch",
        [],
        "\nDirectly affected components",
        [],
        "\nTransitively affected components",
        [],
        "\nTest scripts to run",
        []
      ]
    )
  end

  it "accepts alternative target branch, calculates based on last commit there" do
    start_path = File.expand_path(File.join(__FILE__, "..", "..", "..", "spec", "examples", "letters"))
    root_path = File.join(start_path, 'C')
    root_dir = `cd #{root_path} && git rev-parse --show-toplevel`.chomp

    since = "origin/master"
    changes = `cd #{root_dir} && git diff --name-only #{since}`.split("\n").map { |file| File.join(root_dir, file) }
    options = { display: "verbose", since: since }

    Cbratest::Runner.new(options).run(root_path)
    expect(@puts).to include("\nChanges since last commit on origin/master")
    expect(@puts).to include(changes)
  end
end
