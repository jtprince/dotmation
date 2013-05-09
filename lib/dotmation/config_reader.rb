require 'dotmation/repo'

class Dotmation

  class ConfigReader
    # returns a list of links and a hash of any other values given outside
    # standard blocks
    def read(config_data, config_filename=nil)
      @available_repos = Repo.classes_as_lc_symbols
      @data = {}
      @repos = []
      args = [config_filename].compact
      eval( config_data, binding, *args )
      [@data, @repos]
    end

    def method_missing(methd, *argv, &block)
      if Dotmation::Repo::Link::METHODS.include?(methd)
        @repos.last.links << Dotmation::Repo::Link.new(methd, *argv)
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
