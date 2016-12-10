$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "resquire"

# you can add gems when you create a new analyzer, as an array
analyzer = Resquire::Analyzer.new(:gems => ['colorize', 'packetfu', 'lolize'])

# you can also add gems individually
analyzer.add_gem('pcaprub')
# => true

# or as an array
analyzer.add_gems(['ipaddr', 'socket', 'thread'])
# => true

# you can get an array of the redundant gems
analyzer.redundant_gems
# => ["pcaprub", "ipaddr", "socket", "thread"]

# or the new optimized gem listing as an array with the redundancies
analyzer.optimized_gems
# => ["colorize", "lolize", "packetfu"]

puts analyzer.optimized_gems
