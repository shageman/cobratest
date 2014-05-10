require 'spec_helper'

describe Cbratest do
  before do
    @puts = []
    Cbratest::Runner.any_instance.stub(:output) do |arg|
      @puts << arg
    end
  end

  it "outputs all affected components in verbose mode" do
    start_path = File.expand_path(File.join(__FILE__, "..", "..", "..", "spec", "examples", "letters", "A"))

    Cbratest::Runner.new(true).run(start_path)
    #expect(@puts).to eq([])
  end
end
