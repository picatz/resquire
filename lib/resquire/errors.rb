module Resquire

  # ResquireError handles the custom error handling for this Gem
  #
  # == Example
  #
  #  # Typical use case
  #  raise ResquireError.new("This is a custom error!")
  #
  class ResquireError < StandardError
    attr_reader :problem
    def initialize(problem="Willow Run seems to have encountered a problem.")
      @problem = problem
      super(@problem)
    end
  end
end
