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

    describe 'updating with local files' do
      before do
        cfg = <<MESSAGE
        local "Dropbox/special_stash" do
          dot "dot-fonts", "fonts"
        end
MESSAGE
HERE!
        @dotmation = Dotmation.new()
      end
    end

    describe 'a real update', :pending =>  'only run occasionally -- requires internet' do
    #describe 'an update', :pending => 'only run occasionally -- requires internet' do
      let(:dotmation) { Dotmation.new(@config) }

      before(:all) do 
        @tmprepos_dir = TESTFILES + "/tmprepos"
        @fake_home = TESTFILES + '/fake_home'
        FileUtils.mkpath @fake_home
        @fake_config_home = TESTFILES + '/fake_home/config'
        FileUtils.mkpath @fake_config_home
        @orig_home = ENV['HOME']
        ENV['HOME'] = @fake_home
      end

      # turn on when you want to test github download
      it 'downloads github repos' do
        dotmation.update( home: @fake_home, config_home: @fake_config_home )
        ["jtprince/dotfiles", "robbyrussell/oh-my-zsh"].each do |path|
          # The repos are all there
          base = @tmprepos_dir + "/" + path
          git_file = base + "/.git"
          File.directory?( git_file ).should be_true
        end

        # the links are all there
        %w(dotmation dunstrc zsh i3/config).each do |f|
          link = @fake_config_home + '/' + f
          File.symlink?(link).should be_true
          File.exist?(link).should be_true
          case f
          when 'dotmation', 'zsh'
            File.directory?(link).should be_true
          end
        end

        File.exist?(@fake_home + '/' + '.fonts')
        File.symlink?(@fake_home + '/' + '.fonts')
      end

      xit 'updates existing repos' do
        dotmation.update
      end

      after(:all) do
        #FileUtils.rm_rf(@tmprepos_dir) if File.directory?(@tmprepos_dir)
        #FileUtils.rm_rf(@fake_home)
        #FileUtils.rm_rf(@fake_config_home)
        ENV['HOME'] = @orig_home
      end
    end

  end
end
