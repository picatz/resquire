$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "resquire"

builder = Resquire::Builder.new(:deps => ['colorize', 'packetfu', 'lolize'])

builder.deps << "pcaprub"

builder.redundant_dependencies?
# => ["pcaprub"]

