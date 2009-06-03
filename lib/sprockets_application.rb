module SprocketsApplication
  class << self
    def routes(map)
      map.sprockets resource_path, :controller => 'sprockets', :action => "show"
    end
    
    def source
      concatenation.to_s
    end
    
    def install_script
      concatenation.save_to(asset_path)
    end
    
    def install_assets
      secretary.install_assets
    end

    protected
      def secretary
        @secretary ||= Sprockets::Secretary.new(configuration.merge(:root => RAILS_ROOT))
      end
    
      def configuration
        @configuration ||= begin
          YAML.load(IO.read(File.join(RAILS_ROOT, "config", "sprockets.yml"))) || {}
        end
      end

      def concatenation
        secretary.reset! unless source_is_unchanged?
        secretary.concatenation
      end
      
      def resource_path
        configuration[:resource_path]
      end

      def asset_path
        File.join(Rails.public_path, resource_path)
      end
      
      def source_is_unchanged?
        previous_source_last_modified, @source_last_modified = 
          @source_last_modified, secretary.source_last_modified
          
        previous_source_last_modified == @source_last_modified
      end
  end
end
