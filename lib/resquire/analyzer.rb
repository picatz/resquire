module Resquire

  class Analyzer
    # gem dependencies, as an array
    attr_reader :gems
    attr_reader :redundant_gems

    def initialize(args={})
      @gems = []
      @redundant_gems = []
      if args[:gems]
        if args[:gems].is_a? Array
          add_gems(args[:gems])
        else
          raise Resquire::ResquireError.new("Dependencies must be initialized as an array!")
        end
      end
      true
    end

    def add_gems(gems = [])
      gems.uniq.each { |gem| @gems << gem } 
      true
    end

    def add_gem(gem)
      @gems << gem
      @gems = @gems.uniq
      true
    end
    
    def permutations
      (1..@gems.count).reduce(:*) || 1
    end

    def redundant_gems
      find_redundant_gems.empty? ? false : @redundant_gems
    end

    def redundant_gems?
      find_redundant_gems(:question => true).empty? ? false : true
    end

    def optimized_gems
      optimized_gems = @gems.reject { |gem| @redundant_gems.include? gem }
      optimized_gems.empty? ? false : optimized_gems.uniq.sort
    end

    private

    def find_redundant_gems(args={})
      gems = args[:gems] || @gems
      redundant = args[:redundant_gems] || @redundant_gems
      question = args[:question] || false 
      gems = gems.reject { |gem| redundant.include? gem }
      permutation_count = gems.permutation.count
      count = 0
      gems.permutation.each do |gem_group|
        redundant_gem, status = Open3.capture2e("ruby lib/template.rb #{gem_group.join(',')}")
        @redundant_gems << redundant_gem unless status.success?
        break unless status.success?
        if question
          return true unless status.success?
        end
        count += 1
      end
      find_redundant_gems unless count == permutation_count
      redundant
    end

  end

end
