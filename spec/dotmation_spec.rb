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

    describe 'actions' do

      before do
        @dotmation = Dotmation.new(@config)
      end

      it 'creates lots of link objects' do
        @dotmation.links.should be_an(Array)
      end

      it 'knows about repos' do
        @dotmation.data.should be_an(Hash)
      end

    end

  end
end
