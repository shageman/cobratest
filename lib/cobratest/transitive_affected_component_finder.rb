module Cbratest
  class TransitiveAffectedComponentFinder
    def find(affected)
      all_affected = {}
      affected.keys.each do |key|
        gem = GemfileScraper.new(key[:options][:path])
        if gem.transitive_cobra_dependencies.any? { |dep| affected[dep] }
          all_affected[key] = true
        else
          all_affected[key] = affected[key] || false
        end
      end
      all_affected
    end
  end
end