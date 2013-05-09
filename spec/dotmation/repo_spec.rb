require 'spec_helper'

require 'fileutils'
require 'dotmation'

describe Dotmation::Repo do

  describe 'making cfg links' do

    before do
      @preval = ENV['XDG_CONFIG_HOME']
      @cache_dir = File.expand_path(TESTFILES + '/tmp_github')
      @internal_git_dir = @cache_dir + '/user/project'
      FileUtils.mkpath @internal_git_dir
      @file = @internal_git_dir + "/myfile"
      File.write(@file, 'hiya')
    end

    specify 'cfg makes proper links to xdg spec' do
      cfg_dir =  File.expand_path(TESTFILES + '/tmp_cfg')

      repo = Dotmation::Repo::Github.new('user/project')
      repo.cache_dir = @cache_dir

      repo.links << Dotmation::Repo::Link.new(:cfg, "myfile")
      repo.links << Dotmation::Repo::Link.new(:cfg, "myfile", "diff-name")
      repo.links << Dotmation::Repo::Link.new(:cfg, "myfile", "indir/")

      repo.link!(config_home: cfg_dir)

      %w(myfile diff-name indir/myfile).each do |linkname|
        link = cfg_dir + '/' + linkname
        File.symlink?(link).should be_true
        IO.read(link).should == 'hiya'
      end
      FileUtils.rm_rf cfg_dir
    end

    specify 'dot makes proper links to home dir' do
      home_dir =  File.expand_path(TESTFILES + '/tmp_home')
      repo = Dotmation::Repo::Github.new('user/project')
      repo.cache_dir = @cache_dir

      repo.links << Dotmation::Repo::Link.new(:dot, "myfile")
      repo.links << Dotmation::Repo::Link.new(:dot, "myfile", ".AnotherName")
      repo.links << Dotmation::Repo::Link.new(:dot, "myfile", "subdir/AnotherNameLower")
      repo.links << Dotmation::Repo::Link.new(:dot, "myfile", "NoLeadingDot")
      repo.links << Dotmation::Repo::Link.new(:dot, "myfile", "subdir2/")

      repo.link!(home: home_dir)

      %w(.myfile .AnotherName subdir/AnotherNameLower NoLeadingDot subdir2/myfile).each do |linkname|
        link = home_dir + '/' + linkname
        File.symlink?(link).should be_true
        IO.read(link).should == 'hiya'
      end
      FileUtils.rm_rf home_dir
    end

    specify 'ln just makes the link to home dir' do
      home_dir =  File.expand_path(TESTFILES + '/tmp_home')
      repo = Dotmation::Repo::Github.new('user/project')
      repo.cache_dir = @cache_dir

      repo.links << Dotmation::Repo::Link.new(:ln, "myfile")
      repo.links << Dotmation::Repo::Link.new(:ln, "myfile", ".AnotherName")
      repo.links << Dotmation::Repo::Link.new(:ln, "myfile", "subdir/AnotherNameLower")
      repo.links << Dotmation::Repo::Link.new(:ln, "myfile", "NoLeadingDot")
      repo.links << Dotmation::Repo::Link.new(:ln, "myfile", "subdir2/")

      repo.link!(home: home_dir)

      %w(myfile .AnotherName subdir/AnotherNameLower NoLeadingDot subdir2/myfile).each do |linkname|
        link = home_dir + '/' + linkname
        File.symlink?(link).should be_true
        IO.read(link).should == 'hiya'
      end
      FileUtils.rm_rf home_dir
    end

    after do
      ENV['XDG_CONFIG_HOME'] = @preval
      FileUtils.rm_rf @cache_dir
    end

  end
end
