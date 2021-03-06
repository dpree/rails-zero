module RailsZero
  class Config
    class Backend
      attr_accessor :url

      def url
        @url ||= 'http://localhost:3000'
      end
    end

    class GitDeployment
      attr_accessor :url,
                    :git_binary,
                    :git_remote_ref

      def git_binary
        @git_binary ||=
          File.expand_path(File.join('..', '..', '..', 'bin', 'git'), __FILE__)
      end

      def git_remote_ref
        @git_remote_ref ||= 'master'
      end
    end

    class Site
      attr_writer :paths, :paths_builders

      def paths
        paths = []
        paths.concat(@paths) if defined?(@paths)
        paths.concat(map_paths_from_paths_builders)
        paths.flatten
      end

      def add_paths paths
        @paths ||= []
        @paths << paths
      end

      def add_path path
        @paths ||= []
        @paths << path
      end

      def define_lazy_paths &block
        @lazy_paths = block
      end

      def paths_to_except_from_cleanup
        @paths_to_except_from_cleanup ||= %w[
          404.html
          422.html
          500.html
          favicon.ico
          robots.txt
          assets
        ]
      end

    private

      def map_paths_from_paths_builders
        if defined? @paths_builders
          @paths_builders.map{|b| b.call}
        else
          []
        end
      end
    end

    attr_reader :backend,
                :deployment,
                :site

    def initialize
      @backend = Backend.new
      @deployment = GitDeployment.new
      @site = Site.new
    end
  end
end
