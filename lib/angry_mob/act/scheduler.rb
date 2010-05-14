class AngryMob
  class Act
    class Scheduler
      attr_writer :node
      attr_reader :acted

      def initialize(mob)
        @mob = mob
        reset!
      end

      def ui; @mob.ui end

      def reset!
        @act_names = nil
        @acted = []
      end

      def act_names
        @act_names ||= @node.acts || []
      end

      def acts
        @acts ||= Dictionary.new
      end

      def add_act(name,act)
        acts[name.to_s] = act
      end

      def run!
        each_act {|act| act_now(act)}
        ui.good "finished running acts"
        finalise_acts!
      end

      def each_act
        while act_name = next_act
          act = acts[act_name] || raise(AngryMob::MobError,"no act named '#{act_name}'")
          yield act
        end
        @iterating = false
      end

      def start_iterating!(with=act_names)
        unless @iterating
          @iterating_act_names = with.dup
          @iterating = true
        end
      end

      def next_act
        start_iterating!
        @iterating_act_names.shift
      end

      def schedule_act(*acts)
        raise(CompilationError, "schedule_act called when not compiling") unless @iterating
        ui.info "scheduling #{acts.inspect}"
        @iterating_act_names += acts
      end

      def schedule_acts_matching(regex=nil,&block)
        raise(CompilationError, "schedule_act called when not compiling") unless @iterating

        act_keys = acts.keys

        acts_to_schedule = if regex
                              act_keys.grep(regex)
                            else
                              act_keys.select(&block)
                            end

        schedule_act(*acts_to_schedule)
      end

      def finalise_acts!
        to_finalise = acted.map {|name| "finalise/#{name}"} & acts.keys
        ui.info "running acts finalisers #{to_finalise.inspect}"

        start_iterating!(to_finalise)
        each_act {|act| act_now(act)}
      end

      def act_now(act)
        unless AngryMob::Act === act
          act = acts[act]
        end

        raise(AngryMob::MobError, "no act named '#{act}'") unless act

        name = act.name.to_s

        if acted.include?(name)
          ui.skipped! "(not re-running act #{name} - already run)"
          return
        end

        acted << name

        act.run!
      end
    end
  end
end
