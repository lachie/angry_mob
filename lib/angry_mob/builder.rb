require 'pathname'
require 'tsort'

class AngryMob
  class Builder
    include Log

    attr_reader :attributes

    def initialize(attributes)
      @attributes = attributes
    end

    def self.from_file(path)
      path = Pathname(path)
      new.from_file(path)
    end

    attr_reader :node_consolidation_block

    def file
      if @file
        @file
      else
        '<no-file>'
      end
    end

    # read and evaluate a file in builder context
    def from_file(path)
      @file = path
      instance_eval path.read, path.to_s
      @file = nil
      self
    end

    def to_mob
      mob = Mob.new

      # pre-setup - combine blocks added
      mob.setup_node = lambda {|node,defaults|
        node_setup_blocks.each {|blk| blk[node,defaults]}
      }

      # in-setup - combine blocks added
      mob.node_defaults = lambda {|node,defaults|
        node_default_blocks.each {|blk| blk[node,defaults]}
      }

      # post-setup
      mob.consolidate_node = @node_consolidation_block

      # create and bind acts
      acts.each do |(act,definition_file)|
        act.extend helper_mod 
        act.bind(mob,definition_file)
      end

      # bind event processors
      event_processors.each do |ev_proc|
        ev_proc.bind(mob)
      end

      mob
    end

    #### DSL API

    # Defines an `act` block
    def act(*args, &blk)
      act = Act.new(*args,&blk)
      acts << [act,file.dup]
    end

    def multi_act(name, options={}, &blk)
      options[:multi] = true
      act = Act.new(name,options,&blk)

      acts << [act,file.dup]
    end

    def event(*args,&blk)
      event_processors << AngryMob::Act::EventProcessor.new(*args,&blk)
    end

    def act_helper(&blk)
      helper_mod.module_eval(&blk)
    end

    # A `setup_node` block allows the mob to set defaults, load resource locators and anything else you like.
    def setup_node(&blk)
      node_setup_blocks << blk
    end

    def consolidate_node(&blk)
      @node_consolidation_block = blk
    end

    # Defaults
    def node_defaults(&blk)
      node_default_blocks << blk
    end


    protected
    def node_setup_blocks
      @node_setup_blocks ||= []
    end

    def node_default_blocks
      @node_default_blocks ||= []
    end

    def acts
      @acts ||= []
    end

    def event_processors
      @event_processors ||= []
    end

    def helper_mod
      @helper_mod ||= Module.new
    end
  end
end
