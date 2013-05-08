require 'fileutils'

class Dotmation
  module Repo
    Sys = FileUtils

    Link = Struct.new(:methd, :file, :linkname)
    class Link
      METHODS = [:dot, :cfg, :ln]
    end

    def self.classes_as_lc_symbols
      self.constants.map {|v| v.to_s.downcase.to_sym }
    end

    attr_accessor :path
    attr_accessor :links

    def initialize(path)
      @path = path
      @links = []
    end

    def type
      self.class.to_s.downcase.split('::').last.to_sym
    end

    class Local
      include Repo
    end

    class Github
      include Repo
      attr_accessor :cache_dir

      def path_parts
        @path_parts ||= path.split('/')
      end

      def repo_name
        path_parts[0,2].join('/')
      end

      def user
        path_parts.first
      end

      def project
        path_parts[1]
      end

      def extra_path
        path_parts[2..-1].join('/')
      end

      # makes sure the directory exists.  If it is a file, deletes the file
      # and makes a directory
      def ensure_dir(dir)
        if File.exist?(dir)
          unless File.directory?(dir)
            File.rm_f(dir)
            ensure_dir(dir)
          end
        else
          Sys.mkpath(dir)
        end
        true
      end

      def link!(opts={})
        opts[:config_home] ||= Dotmation::CONFIG_HOME 
        ensure_dir( opts[:config_home] )

        Dir.chdir(cache_dir) do
          Dir.chdir(self.path) do 
            @links.each do |link|

              if link.linkname && link.linkname[-1] == "/"
                ensure_dir( link.linkname )
                link.linkname = link.linkname[0...-1]
              end

              symlink = 
                case link.methd
                when :cfg
                  File.join( opts[:config_home], link.linkname || '' )
                when :dot
                  unless link.linkname
                    File.join( ENV['HOME'], (link.file[0]=='.') ? link.file : ".#{link.file}" )
                  end
                when :ln
                  File.join( ENV['HOME'], link.file )
                end
              Sys.ln_sf(File.expand_path(link.file), symlink)
            end
          end
        end
      end

    end
  end
end
