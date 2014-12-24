module Cobratest
  class TestsToRunSelector
    def list(affected)
      affected.keys.inject([]) do |memo, key|
        memo << File.join(key[:options][:path], "test.sh") if affected[key]
        memo
      end
    end
  end
end
