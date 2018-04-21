require 'set'
require 'pathname'

module Cbratest
  require_relative "cobratest/gemfile_scraper"
  require_relative "cobratest/affected_component_finder"
  require_relative "cobratest/transitive_affected_component_finder"
  require_relative "cobratest/tests_to_run_selector"

  class Runner
    def initialize(opts)
      @verbose_output = opts[:display] == "verbose"
      @since = opts[:since] || "current branch"
      @test_runner = opts[:runner] || "test.sh"
    end

    def run(root_path)
      path = root_path || current_path
      app = GemfileScraper.new(path)

      outputs "All components"
      cobra_deps = app.transitive_cobra_dependencies.to_set
      components = cobra_deps << app.to_s
      outputs component_out(components.to_a)

      outputs "\nChanges since last commit on #{@since}"
      root_dir = `cd "#{path}" && git rev-parse --show-toplevel`.chomp
      if @since != "current branch"
        changes = `cd "#{root_dir}" && git diff --name-only #{@since}`.split("\n").map { |file| File.join(root_dir, file) }
      else
        changes = `cd "#{root_dir}" && git status -s -u`.split("\n").map { |file| File.join(root_dir, file.sub(/^.../, "")) }
      end
      outputs changes

      outputs "\nDirectly affected components"
      affected = AffectedComponentFinder.new.find(components, changes)
      outputs affected_out(affected)

      outputs "\nTransitively affected components"
      all_affected = TransitiveAffectedComponentFinder.new.find(affected)
      outputs affected_out(all_affected)

      outputs "\nTest scripts to run"
      outputs all_in_need_of_running = TestsToRunSelector.new(@test_runner).list(all_affected), true
    end

    private

    def outputs(arg, even_non_verbose = false)
      output(arg) if even_non_verbose || @verbose_output
    end

    def output(arg)
      puts arg
    end

    def component_out(array)
      array.map do |component|
        "#{component[:name].ljust(max_key_width(array))} #{component[:options][:path]}"
      end
    end

    def affected_out(hash)
      hash.keys.inject([]) do |memo, component|
        memo << "#{component[:name].ljust(max_key_width(hash.keys))} #{component[:options][:path]}" if hash[component]
        memo
      end
    end

    def max_key_width(array)
      array.inject(0) do |memo, component|
        [memo, component[:name].length].max
      end + 2
    end
  end
end
