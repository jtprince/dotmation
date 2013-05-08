require 'open-uri'
require 'fileutils'

class Dotmation

  CONFIG_HOME = ENV['XDG_CONFIG_HOME'] || "#{ENV['HOME']}/.config"
  DEFAULT_CONFIG_PATH = CONFIG_HOME + '/dotmation/config'
  DEFAULT_CONFIG_GITHUB_PATH = "config/dotmation/config"
  GITHUB_REPO_BASE = "https://github.com"

  attr_accessor :config_data

  attr_accessor :data
  attr_accessor :repos

  # quick check to see if this looks like a dotmation config file
  def is_config?
    @config_data.match(/dot|xdg/)
  end

  # arg is the path to the config file (checks for existence first) or a
  # github name.
  def initialize(arg=DEFAULT_CONFIG_PATH)
    @config_data = 
      if File.exist?(arg)
        @config_filename = arg
        IO.read(arg)
      else # github name
        uri = "https://raw.github.com/#{arg}/#{DEFAULT_CONFIG_GITHUB_PATH}"
        open(uri) {|io| io.read }
      end
    warn "couldn't find config file locally or on github" unless is_config?
    read_config!
  end

  def repo_cache
    @repo_cache ||= File.expand_path(@data[:repo_cache])
  end

  def update
    update_github_repos!
  end

  def update_github_repos!
    FileUtils.mkpath(repo_cache) unless File.directory?(repo_cache)
    Dir.chdir(repo_cache) do
      repos_grouped_by_name(:github).each do |user_repo, repos|
        (user, repo) = user_repo.split('/')
        FileUtils.mkdir(user) unless File.directory?(user)
        Dir.chdir(user) do
          if File.directory?(repo)
            Dir.chdir(repo) { print `git pull` }
          else
            print `git clone #{GITHUB_REPO_BASE}/#{user}/#{repo}.git`
          end
        end
      end
    end
  end

  def repos_grouped_by_name(type=:github)
    repos.select {|r| r.type == type }.group_by {|r| r.repo_name }
  end

  def read_config!
    (@data, @repos) = ConfigReader.new.read(@config_data, @config_filename)
  end

  module Repo
    attr_accessor :path
    attr_accessor :links

    def initialize(path)
      @path = path
      @links = []
    end

    def type
      self.class.to_s.downcase.split('::').last.to_sym
    end


    def self.classes_as_lc_symbols
      self.constants.map {|v| v.to_s.downcase.to_sym }
    end

    class Local
      include Repo
    end

    class Github
      include Repo

      def repo_name
        path[%r{[^/]+/[^/]+}]
      end
    end

  end

  # type is :github or :local
  Link = Struct.new(:methd, :file, :linkname)
  class Link
    METHODS = [:dot, :cfg, :ln]
  end

  class ConfigReader
    # returns a list of links and a hash of any other values given outside
    # standard blocks
    def read(config_data, config_filename=nil)
      @available_repos = Repo.classes_as_lc_symbols
      @data = {}
      @repos = []
      eval config_data, binding, config_filename
      [@data, @repos]
    end

    def method_missing(methd, *argv, &block)
      if Link::METHODS.include?(methd)
        @repos.last.links << Link.new(methd, *argv)
      elsif @available_repos.include?(methd) && block
        @repos << Repo.const_get(methd.to_s.capitalize).new( *argv )
        instance_eval(&block)
      else
        arg = (argv.size==1 ? argv.first : argv)
        @data[methd] = arg
      end
    end
  end
end
