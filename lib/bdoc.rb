$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'rubygems'
require 'erb'
require 'tmpdir'
require 'launchy'
require 'multi_json'

if VERSION == /^1.9/
  Encoding.default_internal = 'UTF-8'
else
  $KCODE = "u"
end

module Bdoc
  VERSION = '0.3.3'

  class << self
    attr_accessor :output_dir
    attr_accessor :output_index

    def rdoc_file(gem_name)
      File.join(Gem.dir, "doc", gem_name, "rdoc", "index.html")
    end

    def gems_with_doc_index
      installed_gems = Gem::SourceIndex.from_installed_gems.gems.map{|k,v|v}
      gems = installed_gems.map { |g|
        g.name if g.has_rdoc?
      }.compact.uniq.sort{|x,y| x.downcase <=> y.downcase}
      gems = gems.map do |g|
        gem = installed_gems.find_all{|gem| gem.name == g}.last
        { :name => g,
          :description => gem.description,
          :homepage => gem.homepage,
          :versions => installed_gems.find_all{|gem| 
            gem.name == g
            }.map{|gem|
              rdoc_index = File.join(gem.full_gem_path,"..","..","doc",gem.full_name, "rdoc","index.html")
              { :version => gem.version.version,
                :rdoc_index => (File.exist?(rdoc_index) ? rdoc_index : nil)
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
      @gems_json = MultiJson.encode(@gems)

      index = ERB.new(File.read(File.join(File.dirname(__FILE__), '..', "templates","bdoc.html"))).result(binding) 
      Dir.mkdir(output_dir) unless File.exists?(output_dir)
      File.open(output_index,"w") {|f| f.write(index)}
    end

    def open
      generate_index
      Launchy::Browser.run(output_index)
    end
  end

  self.output_dir = ARGV[0] || Dir.tmpdir
  self.output_index = File.join(@output_dir,"bdoc.html")
end
