require 'pp'
class AngryMob
  class Target
    class DefaultResourceLocator
      def resource(target, name)
        candidates = target.resource_search_paths.tapp.map {|path| path + name.to_s }

        candidates.find {|path| path.exist?}.tap {|path|
          unless path
            raise "No resource '#{name}' found for target #{target} (search paths=#{ target.resource_search_paths.map(&:to_s).inspect })"
          end
        }
      end
      alias_method :[], :resource
    end
  end
end
