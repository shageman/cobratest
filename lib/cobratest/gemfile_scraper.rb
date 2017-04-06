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

    def cobra_dependencies
      dirdep = direct_dependencies
      transitive_cobra_dependencies.select do |dep|
        dirdep.include?(dep[:name]) || dep[:options][:direct]
      end
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

    def raw_gemspec
      path = File.expand_path(File.join(@root_path, "#{underscore(name)}.gemspec"))
      File.exist?(path) ? File.read(path) : ""
    end

    def direct_dependencies
      raw_gemspec.split("\n").inject([]) do |memo, line|
        match = line.match(/add_(?:development_)?dependency\s+["']([^'"]+)["']/)
        memo << match[1] if match
        memo
      end
    end

    def raw_gemfile
      path = File.expand_path(File.join(@root_path, "Gemfile"))
      File.read(path)
    end

    def gem_dependencies
      gemfile_path = File.join(@root_path, "Gemfile")
      lockfile_path = File.join(@root_path, "Gemfile.lock")
      ::Bundler::Definition.build(gemfile_path, lockfile_path, nil).dependencies.inject([]) do |memo, dep|
        path = dep.source.path.to_s if dep.source && dep.source.is_a_path?
        if path == "."
          path = nil
        elsif path && !path.match(/#{dep.name}/)
          path = "#{path}/#{dep.name}"
        end
        memo << { name: dep.name, options: { path: path }}
        memo
      end
    end

    def underscore(string)
      string.gsub(/::/, '/').
          gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2').
          gsub(/([a-z\d])([A-Z])/, '\1_\2').
          tr("-", "_").
          downcase
    end
  end
end
