require 'spec_helper'

require 'dotmation'

describe Dotmation do
  describe 'reading a config file' do
    before do
      @config = TESTFILES + "/config"
    end

    it 'can read it' do
      dotmation = Dotmation.new(@config)
    end

    describe 'the data' do

      let(:dotmation) { Dotmation.new(@config) }

      it 'knows data' do
        data = dotmation.data
        data.should be_an(Hash)
        data[:repo_cache].should == "spec/testfiles/tmprepos"
      end

      it 'has repos with links' do
        repos = dotmation.repos
        repos.size.should == 4
        repos.map(&:type).partition.to_a.should == [:github, :github, :local, :github]
      end

      it 'knows which git repos it needs to get' do
        dotmation.repos_grouped_by_name.keys.should == ["jtprince/dotfiles", "robbyrussell/oh-my-zsh"]
      end

    end

    describe 'an update' do
    #describe 'an update', :pending => 'only run occasionally -- requires internet' do
      let(:dotmation) { Dotmation.new(@config) }

      before(:all) do 
        @tmprepos_dir = TESTFILES + "/tmprepos"
      end

      # turn on when you want to test github download
      it 'downloads github repos' do
        dotmation.update
        ["jtprince/dotfiles", "robbyrussell/oh-my-zsh"].each do |path|
          base = @tmprepos_dir + "/" + path
          git_file = base + "/.git"
          File.exist?( git_file ).should be_true
        end
      end

      it 'updates existing repos' do
        dotmation.update
      end

      after(:all) do
        FileUtils.rm_rf(@tmprepos_dir) if File.directory?(@tmprepos_dir)
      end
    end

  end
end
