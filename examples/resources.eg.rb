require 'eg_helper'
require 'angry_mob'

Here = Pathname("..").expand_path(__FILE__)


def load_mob
  @attributes = AngryHash[:fire => %w{start}]
  @mob_loader = AngryMob::MobLoader.new(@attributes)

  @mob_loader.add_mob("~/dev/blake/common_mob")
  @mob_loader.add_mob(Here+"mob")

  @rioter = @mob_loader.to_rioter
end


eg 'load' do
  load_mob

  # Show( AngryMob::Target::Tracking.subclasses.map {|k,s| [k,s.to_s] } )

  @rioter.riot!('example', @attributes)
end
