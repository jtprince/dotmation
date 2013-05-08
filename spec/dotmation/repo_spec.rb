require 'spec_helper'

require 'fileutils'
require 'dotmation'

describe Dotmation::Repo do

  describe 'making cfg links' do

    before(:all) do
      @cfg_dir =  File.expand_path(TESTFILES + '/tmp_cfg')
      @preval = ENV['XDG_CONFIG_HOME']
      @cache_dir = File.expand_path(TESTFILES + '/tmp_github')
      @internal_git_dir = @cache_dir + '/silly/willy'
      FileUtils.mkpath @internal_git_dir
      @file = @internal_git_dir + "/myfile"
      File.write(@file, 'hiya')
    end

    it 'cfg makes proper links to xdg spec' do
      repo = Dotmation::Repo::Github.new('silly/willy')
      repo.cache_dir = @cache_dir

      repo.links << Dotmation::Repo::Link.new(:cfg, "myfile")
      repo.links << Dotmation::Repo::Link.new(:cfg, "myfile", "diff-name")
      repo.links << Dotmation::Repo::Link.new(:cfg, "myfile", "indir/")

      repo.link!(config_home: @cfg_dir)

      %w(myfile diff-name indir/myfile).each do |linkname|
        link = @cfg_dir + '/' + linkname
        File.symlink?(link).should be_true
        IO.read(link).should == 'hiya'
      end
    end

    #it 'dot makes proper links to home dir' do
      #repo = Dotmation::Repo::Github.new('silly/willy')
      #repo.cache_dir = @cache_dir
      #repo.links << Dotmation::Repo::Link.new(:cfg, "myfile")
      #repo.link!(config_home: @cfg_dir)
      #link = @cfg_dir + '/myfile'
      #File.symlink?(link).should be_true
      #IO.read(link).should == 'hiya'
    #end

    after(:all) do
      ENV['XDG_CONFIG_HOME'] = @preval
      #FileUtils.rm_rf @cache_dir
      #FileUtils.rm_rf @cfg_dir
    end

  end
end
