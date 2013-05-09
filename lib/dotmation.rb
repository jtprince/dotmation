require 'open-uri'
require 'fileutils'
require 'dotmation/config_reader'
require 'dotmation/repo'

class Dotmation

  CONFIG_HOME = ENV['XDG_CONFIG_HOME'] || "#{ENV['HOME']}/.config"
  DEFAULT_CONFIG_PATH = CONFIG_HOME + '/dotmation/config'
  DEFAULT_CONFIG_GITHUB_REPO = "dotfiles"
  DEFAULT_CONFIG_GITHUB_PATH = "config/dotmation/config"
  GITHUB_REPO_BASE = "https://github.com"
  DEFAULT_REPO_CACHE_DIR = "~/dotfile_repo"

  attr_accessor :config_data

  attr_accessor :data
  attr_accessor :repos

  # quick check to see if this looks like a dotmation config file
  def is_config?
    @config_data.match(/dot|xdg/)
  end

  # arg is the path to the config file (checks for existence first), a url or
  # a github name.  If given a file then it can give line number error
  # messages.
  def initialize(arg=DEFAULT_CONFIG_PATH)
    @config_data = 
      if File.exist?(arg)
        @config_filename = arg
        IO.read(arg)
      else # url or github name
        uri = 
          if arg.include?("://")
            arg
          else
            "https://raw.github.com/#{arg}/#{DEFAULT_CONFIG_GITHUB_REPO}/master/#{DEFAULT_CONFIG_GITHUB_PATH}"
          end
        open(uri) {|io| io.read }
      end
    warn "couldn't find config file locally or on github" unless is_config?
    read_config!
  end

  def repo_cache
    if @repo_cache
      @repo_cache
    else
      @repo_cache =
        if @data[:repo_cache]
          File.expand_path(@data[:repo_cache]) 
        else
          File.expand_path(DEFAULT_REPO_CACHE_DIR)
        end
    end
  end

  def update(opts={})
    unless opts[:no_update_github]
      update_github_repos!
    end
    link!
  end

  def link!
    repos.each(&:link!)
  end

  def update_github_repos!
    FileUtils.mkpath(repo_cache) unless File.directory?(repo_cache)
    Dir.chdir(repo_cache) do
      repos_grouped_by_name(:github).each do |user_repo, repos|
        repos.each {|r| r.cache_dir = repo_cache }
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

end
