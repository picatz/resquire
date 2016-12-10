module Resquire

  class Builder
    # gem dependencies, as an array
    attr_accessor :deps

    def initialize(args={})
      @deps = []
      if args[:deps] or args[:depenendcies]
        if args[:deps].is_a? Array or args[:depenendcies].is_a? Array
          args_deps = args[:deps] || args[:depenendcies]
          add_dependencies(args_deps)
        else
          raise Resquire::ResquireError.new("Dependencies must be initialized as an array!")
        end
      end
      true
    end

    def add_dependencies(dependencies = [])
      return false if dependencies.empty?
      dependencies.uniq.each { |dep| @deps << dep } 
      true
    end

    def redundant_dependencies?(dependencies = @deps)
      redundant_gems = []
      dependencies.permutation.each do |dependency_group|
        redundant_gem = find_redundant_depencies(dependency_group)
        redundant_gems << redundant_gem if redundant_gem
      end
      redundant_gems = redundant_gems.uniq
      redundant_gems.empty? ? false : redundant_gems
    end

    private

    def find_redundant_depencies(dependencies = @deps)
      unless dependencies.empty?
        redundant_gem, status = Open3.capture2e("ruby lib/template.rb #{dependencies.join(',')}")
        if status.success?
          return false
        else
          return redundant_gem
        end
      end
      false
    end
  end

end
