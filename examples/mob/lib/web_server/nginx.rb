require 'web_server'

class Nginx < WebServer
  def run!(node, *args)
    puts "nginx!"
    puts definition_file

    foo "/tmp/thing.txt", :src => "thething.txt"
  end
end
