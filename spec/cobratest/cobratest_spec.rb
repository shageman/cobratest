require 'spec_helper'

describe Cbratest do
  before do
    @puts = []
    Cbratest::Runner.any_instance.stub(:output) do |arg|
      @puts << arg
    end
  end

  it "outputs all affected components in verbose mode" do
    start_path = File.expand_path(File.join(__FILE__, "..", "..", "..", "spec", "examples", "letters"))

    Cbratest::Runner.new(true).run(File.join(start_path, 'A'))
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
                             "\nChanges since last commit",
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
end