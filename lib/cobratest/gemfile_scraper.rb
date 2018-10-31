require "bundler"

module Cbratest
  class GemfileScraper
    def initialize(root_path)
      @root_path = root_path
    end

    def name
      Pathname.new(@root_path).basename.to_s
    end

    def to_s
      {name: name, options: {path: @root_path}}
    end

    def transitive_cobra_dependencies
      gem_dependencies.inject([]) do |memo, dep|
        if !!dep[:options][:path]
          absolute_dep = dep.clone
          absolute_dep[:options][:path] = File.expand_path(File.join(@root_path, dep[:options][:path]))
          memo << dep
        end
        memo
      end
    end

    private

    def gem_dependencies
      gemfile_path = File.join(@root_path, "Gemfile")
      lockfile_path = File.join(@root_path, "Gemfile.lock")
      ::Bundler::Definition.build(gemfile_path, lockfile_path, nil).dependencies.inject([]) do |memo, dep|
        path = dep.source.path.to_s if dep.source && dep.source.path?
        if path == "."
          path = nil
        elsif path && !path.match(/#{dep.name}/)
          path = "#{path}/#{dep.name}"
        end
        memo << { name: dep.name, options: { path: path }}
        memo
      end
    end
  end
end
