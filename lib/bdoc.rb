$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'rubygems'
require 'erb'
require 'tmpdir'
require 'launchy'
require 'json/pure'

module Bdoc
  VERSION = '0.1.2'

  class << self
    attr_accessor :output_dir
    attr_accessor :output_index

    def rdoc_file(gem_name)
      File.join(Gem.dir, "doc", gem_name, "rdoc", "index.html")
    end

    def gems_with_doc_index
      gems = Gem::Specification.list.map { |g|
        rdoc_index = rdoc_file(g.full_name)
        if File.exist?(rdoc_index)
          g.name if g.has_rdoc?
        end
      }.compact.uniq.sort{|x,y| x.downcase <=> y.downcase}
      gems = gems.map do |g|
        gem = Gem::Specification.list.find_all{|gem| gem.name == g}.last
        { :name => g,
          :description => gem.description,
          :homepage => gem.homepage,
          :versions => Gem::Specification.list.find_all{|gem| 
            gem.name == g && File.exist?(rdoc_file(gem.full_name))
          }.map{|gem|
            rdoc_index = File.join(Gem.dir, "doc", gem.full_name, "rdoc", "index.html")
            { :version => gem.version.version,
              :rdoc_index => rdoc_index
            }
          #removes dups since uniq doesn't work on array of hashes
          }.compact.sort_by{|g|g[:version]}.inject([]){|result,h| 
            result << h unless result.include?(h)
            result
          }
        }
      end
    end

    def generate_index
      @gems = gems_with_doc_index
      index = ERB.new(File.read(File.join(File.dirname(__FILE__), '..', "templates","index.html"))).result(binding) 
      Dir.mkdir(output_dir) unless File.exists?(output_dir)
      File.open(output_index,"w") {|f| f.write(index)}
      FileUtils.cp_r Dir.glob('templates/*.js'), output_dir
      FileUtils.cp_r Dir.glob('templates/*.css'), output_dir
    end

    def open
      generate_index
      Launchy::Browser.run(output_index)
    end
  end

  self.output_dir = File.join(Dir.tmpdir,"bdoc")
  self.output_index = File.join(@output_dir,"index.html")
end
