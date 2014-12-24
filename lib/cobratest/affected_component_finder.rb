module Cobratest
  class AffectedComponentFinder
    def find(components, changes)
      components.inject({}) do |memo, component|
        memo[component] = false
        changes.each do |change|
          if change.start_with? component[:options][:path]
            memo[component] = true
          end
        end
        memo
      end
    end
  end
end
