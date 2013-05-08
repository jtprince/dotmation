require 'open-uri'

class Dotmation

  CONFIG_HOME = ENV['XDG_CONFIG_HOME'] || "#{ENV['HOME']}/.config"
  DEFAULT_CONFIG_PATH = CONFIG_HOME + '/dotmation/config'
  GITHUB_PATH = "config/dotmation/config"

  attr_accessor :config_data

  attr_accessor :data
  attr_accessor :links

  # quick check to see if this looks like a dotmation config file
  def is_config?
    @config_data.match(/dot|xdg/)
  end

  # arg is the path to the config file (checks for existence first) or a
  # github name.
  def initialize(arg=DEFAULT_CONFIG_PATH)
    @config_data = 
      if File.exist?(arg)
        IO.read(arg)
      else # github name
        uri = "https://raw.github.com/#{arg}/#{GITHUB_PATH}"
        open(uri) {|io| io.read }
      end
    warn "couldn't find config file locally or on github" unless is_config?
    read_config!
  end

  # returns the github repos from the links
  def repos_from_links(links)
    abort 'IMPLEMENT!'
  end

  def read_config!
    (@data, @links) = ConfigReader.new.read(@config_data)
  end

  # type is :github or :local
  Link = Struct.new(:type, :methd, :file, :linkname)

  class Link
    TYPES = [:local, :github]
    METHODS = [:dot, :cfg, :ln]
  end

  class ConfigReader
    # returns a list of links and a hash of any other values given outside
    # standard blocks
    def read(config_data)
      @data = {}
      @links = []
      eval config_data
      [@data, @links]
    end

    def method_missing(methd, *argv, &block)
      p methd
      methd = methd.to_sym
      if Link::METHODS.include?(methd)
        @links << Link.new(@last_type, methd, *argv)
      elsif Link::TYPES.include?(methd) && block
        @last_type = methd
        instance_eval(&block)
      else
        puts "NO METHOD putting in hash: #{methd}"
        arg = (argv.size==1 ? argv.first : argv)
        @data[methd] = arg
      end
    end
  end
end
