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
    
    def permutations(gems = @gems)
      (1..gems.count).reduce(:*) || 1
    end

    def redundant_gems(args={})
      @count = 0
      @permutation_count = permutations
      @progress_bar = args[:progress_bar] || true
      gems = args[:gems] || @gems
      redundant = args[:redundant_gems] || @redundant_gems
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
      gems = @gems.reject { |gem| @redundant_gems.include? gem }
      question = args[:question] || false 
      permutation_count = permutations(gems)
      count = 0
      gems = gems.permutation.to_a.shuffle
      gems.each do |gem_group|
        if @progress_bar
          print "#{count}/#{permutation_count}\r"
        end
        redundant_gem, status = Open3.capture2e("ruby lib/template.rb #{gem_group.join(',')}")
        @redundant_gems << redundant_gem unless status.success?
        break unless status.success?
        if question
          return true unless status.success?
        end
        count += 1
      end
      find_redundant_gems unless count == permutation_count
      @redundant_gems
    end

  end

end
