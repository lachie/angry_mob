class AngryMob
  class Target
    module Resources
      def resource_search_paths
        [ call_file, self.class.definition_file_chain ].flatten.compact.map {|path| path.to_s.sub(/\.([^\.]+)$/,'')}.map {|path| Pathname(path)}
      end
    end
  end
end
