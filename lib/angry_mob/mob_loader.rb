class AngryMob
  class MobLoader

    def load(path)
      path = Pathname(path).expand_path

      @builder = Builder.new

      load_lib(path)
      load_mob(path)

      self
    end

    def load_lib(path)
      $LOAD_PATH << path+'lib'
    end

    def load_mob(path)
      Pathname.glob(path+'mob/**/*.rb').each do |file|
        @builder.from_file(file)
      end
    end

    def to_mob
      @builder.to_mob
    end
  end
end
