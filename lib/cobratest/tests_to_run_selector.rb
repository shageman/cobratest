module Cbratest
  class TestsToRunSelector
    attr_reader :suffix

    def initialize(suffix = 'test.sh')
      @suffix = suffix
    end

    def list(affected)
      affected.keys.inject([]) do |memo, key|
        memo << File.join(key[:options][:path], suffix) if affected[key]
        memo
      end
    end
  end
end
