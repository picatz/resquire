require "resquire/version"
require "resquire/banner"
require "resquire/analyzer"
require "resquire/errors"
require 'open3'

module Resquire

  # I'll put my code wherever I want!
  #
  # ┬─┐┌─┐┌─┐┌─┐ ┬ ┬┬┬─┐┌─┐
  # ├┬┘├┤ └─┐│─┼┐│ ││├┬┘├┤
  # ┴└─└─┘└─┘└─┘└└─┘┴┴└─└─┘
  # ─────────────────────────────────────────────────────────────────────────
  # We'll use this area to describe Resquire a little bit to highlight
  # what we're trying to solve here.
  #
  # So, when we require a gem that itself requires many gems; and if 
  # we were to require one of the gems that a gem we've already required
  # has already required when it was required -- well, we're actually not
  # requiring the gem with the second ( or third, or fourth, ect ) require.
  # Thus, all of those other requires would be redundant, since they're
  # not going anything. In fact, they're simply returning false.
  #
  # Example Scenario:
  # ┌───────────────────────────────────────────────┐
  # │ pry / irb shell                               │
  # ├───────────────────────────────────────────────┤
  # │ require 'packetfu'                            │
  # │ => true                                       │
  # │ require 'pcaprub'                             │
  # │ => false                                      │
  # └───────────────────────────────────────────────┘
  # ─────────────────────────────────────────────────────────────────────────
  # Resquire's Goal:
  # If we can find these redundant requires, then we can figure out how to
  # essentiall optimize our requires and make our applications faster. At 
  # least during require time. 

end
