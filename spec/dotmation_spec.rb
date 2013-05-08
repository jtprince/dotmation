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
        hash = dotmation.repos_grouped_by_name
      end

    end

    describe 'an update' do
      let(:dotmation) { Dotmation.new(@config) }

      it 'downloads github repos' do
        dotmation.update
        ["jtprince/dotfiles", "robbyrussell/oh-my-zsh"].each do |path|
          base = TESTFILES + "/tmprepos/" + path
          git_file = base + "/.git"
          File.exist?( git_file ).should be_true
          FileUtils.rm_rf(base)
        end
      end
    end

  end
end
