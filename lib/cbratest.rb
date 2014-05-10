require 'set'
require 'pathname'
require 'graphviz'

module Cbratest
  require_relative "cbratest/gemfile_scraper"

  def self.run(root_path = nil)
    path = root_path || current_path
    app = GemfileScraper.new(path)

    outputs "Changes since origin/master"

    outputs "Directly affected components"
    outputs "Transitively affected components"
    outputs "Test scripts to run"

    #cbra_deps = app.transitive_cbra_dependencies.to_set
    #outputs cbra_deps.to_a
  end

  def self.outputs(arg)
    puts arg
  end

  private_class_method :outputs
end
