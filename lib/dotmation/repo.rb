require 'fileutils'

class Dotmation
  class TryingToSoftLinkOverExistingDir < Exception
  end

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

    def no_trailing_slash(dir)
      (dir[-1] == '/') ? dir[0...-1] : dir
    end

    # returns true if defined and there is a trailing slash
    def link_to_reside_under_dir?(dir)
      dir && (dir[-1] == '/')
    end

    def ensure_underdir( link )
      dir = File.dirname(link)
      Sys.mkpath(dir)
    end

    # path/file => .file
    # path/.file => .file
    # path/to/file => .file
    # file => .file
    # .file => .file
    def base_dot(file_path)
      base = file_path.split('/').last
      (base[0] == '.') ? base[0] : ('.' + base)
    end

    # clears @link upon all successul linkages
    def link!(opts={})
      opts[:home] ||= ENV['HOME']
      opts[:config_home] ||= Dotmation::CONFIG_HOME
      [:home, :config_home].each {|sym| opts[sym] = no_trailing_slash(opts[sym]) }

      ensure_dir( opts[:config_home] )
      ensure_dir( opts[:home] )

      real_base_dir = self.respond_to?(:cache_dir) ? cache_dir : File.expand_path(opts[:home])

      Dir.chdir(real_base_dir) do
        Dir.chdir(self.path) do 
          @links.each do |link|
            has_slashes = link.linkname && link.linkname.include?("/")
            link_to_reside_under_dir = link_to_reside_under_dir?(link.linkname)
            symlink = 
              case link.methd
              when :cfg
                File.join( opts[:config_home], link.linkname || '' )
              when :dot
                if link.linkname
                  File.join( opts[:home], link.linkname )
                else
                  File.join( opts[:home], (link.file[0]=='.') ? link.file : base_dot(link.file) )
                end
              when :ln
                if link.linkname
                  File.join( opts[:home], link.linkname )
                else
                  File.join( opts[:home], link.file )
                end
              end

            if link.linkname && link.linkname.include?('/')
              ensure_underdir( symlink )
            end
            ensure_dir( symlink ) if link_to_reside_under_dir
            if File.exist?(symlink)
              if File.directory?(symlink) && !link_to_reside_under_dir && !File.symlink?(symlink) && has_slashes
                raise Dotmation::TryingToSoftLinkOverExistingDir, "a real directory already exists where you are trying to place a softlink, delete it before proceeding or trail the symlink with a slash in your config file to put the link under it: #{symlink}"
              elsif !File.directory?(symlink) && !File.symlink?(symlink)
                File.unlink(symlink)
              end
            end
            file_to_link = File.expand_path(link.file)
            #puts "TO LINK AN D SYMLINK:"
            #p File.exist?(file_to_link)
            #p file_to_link
            #p symlink
            Sys.ln_sf(file_to_link, symlink)
          end
          # clear all the links
          @links.clear
        end
      end
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

    end
  end
end
