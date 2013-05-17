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
  def is_config?(data)
    data.match(/dot|xdg/)
  end

  # arg is the path to the config file (checks for existence first), a url or
  # a github name.  If given a file then it can give line number error
  # messages.
  def initialize(arg=nil)
    set_from_config!(arg) if arg
  end

  # given a filename, a url, or a github name, will read the config file.
  # returns self
  def set_from_config!(arg)
    @config_data = 
      if arg.include?("://")
        open(arg) {|io| io.read }
      elsif File.exist?(arg)
        @config_filename = arg
        IO.read(arg)
      else
        url = "https://raw.github.com/#{arg}/#{DEFAULT_CONFIG_GITHUB_REPO}/master/#{DEFAULT_CONFIG_GITHUB_PATH}"
        begin
          open(url) {|io| io.read }
        rescue
          raise RuntimeError, "assuming this is a github account name, but config file does not exist!: #{url}"
        end
      end
    raise "config file doesn't look like config file" unless is_config?(@config_data)
    (@data, @repos) = read_config_data(@config_data, @config_filename)
    self
  end

  def repo_cache
    @repo_cache ||= File.expand_path(data[:repo_cache] || DEFAULT_REPO_CACHE_DIR)
  end

  def update(opts={})
    update_github_repos! unless opts[:no_update_github]
    link!(opts)
  end

  def link!(opts={})
    repos.each {|repo| repo.link!(opts) }
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

  # returns data and repos.  filename is helpful only for debugging.
  def read_config_data(data, filename=nil)
    ConfigReader.new.read(data, filename)
  end

end
