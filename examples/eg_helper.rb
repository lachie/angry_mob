require 'rubygems'
require 'bundler'
Bundler.setup

require 'exemplor'
require 'awesome_print'
require 'pathname'
require 'pp'


module Exemplor
  class AwesomeResultPrinter < ResultPrinter
    def format_info(str, result)
      icon(:info) + ' ' + str + "\n\e[0m" + result.ai(:indent => 2)
    end
  end

  Examples.printer = AwesomeResultPrinter
end


Root = Pathname('../..').expand_path(__FILE__)
$LOAD_PATH << Root+'lib'

require 'angry_mob/vendored'


