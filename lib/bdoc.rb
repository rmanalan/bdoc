$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'rubygems'
require 'erb'
require 'tmpdir'

module Bdoc
  VERSION = '0.1.0'
  class << self
    def gems_with_doc_index
      Gem::Specification.list.map { |g|
        rdoc_index = File.join(Gem.dir, "doc", g.full_name, "rdoc", "index.html")
        if File.exist?(rdoc_index)
          { :name => g.name,
            :version => g.version,
            :homepage => g.homepage,
            :description => g.description, :rdoc_index => rdoc_index } if g.has_rdoc?
        end
      }.compact
    end

    def generate_index
      @gems = gems_with_doc_index
      index = ERB.new(File.read(File.join("templates","index.html"))).result(binding)
      tmpdir = File.join(Dir.tmpdir,"bdoc")
      output = File.join(tmpdir,"index.html")
      Dir.mkdir(tmpdir) unless File.exists?(tmpdir)
      File.open(output,"w") {|f| f.write(index)}
      copy_assets(tmpdir)
      output
    end

    def copy_assets(tmpdir)
      FileUtils.cp_r Dir.glob('templates/*.js'), tmpdir
      FileUtils.cp_r Dir.glob('templates/*.css'), tmpdir
    end
  end
end
