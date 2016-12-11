module Resquire

  class Analyzer
    # gem dependencies, as an array
    attr_reader :gems

    # When we create a new Analyzer, we can specifiy the
    # gems we want to work with, but it must be passed
    # in as an array in the args hash.
    #
    # == Typical Usage
    #
    #  analyzer = Resquire::Analyzer.new(:gems => ['packetfu', 'pcaprub'])
    #
    def initialize(args = {})
      @gems = []
      @redundant_gems = []
      if args[:gems]
        if args[:gems].is_a? Array
          add_gems(args[:gems])
        else
          raise Resquire::ResquireError.new('Dependencies must be initialized as an array!')
        end
      end
      true
    end

    # We can add gems specified from an array.
    #
    # == Typical Usage
    #
    #  analyzer = Resquire::Analyzer.new
    #  analyzer.add_gems(['packetfu', 'pcaprub'])
    #
    def add_gems(gems = [])
      gems.uniq.each { |gem| @gems << gem } 
      true
    end

    # We can add one gem at a time as a string.
    #
    # == Typical Usage
    #
    #  analyzer = Resquire::Analyzer.new
    #  analyzer.add_gem('packetfu')
    #  analyzer.add_gem('pcaprub')
    #
    def add_gem(gem)
      @gems << gem
      @gems = @gems.uniq
      true
    end

    # We can check the given permutations that
    # we will need to cycle through to find gems
    # that are redundant.
    #
    # == Typical Usage
    #
    #  analyzer = Resquire::Analyzer.new(:gems => ['packetfu', 'pcaprub'])
    #  analyzer.permutations
    #   
    def permutations(gems = @gems)
      (1..gems.count).reduce(:*) || 1
    end

    # We can find the redundant gems from the the analyzer has
    # to work with, iterating over the possible permutations and returning
    # an array of redundant gems.
    #
    # == Typical Usage
    #
    #  analyzer = Resquire::Analyzer.new(:gems => ['packetfu', 'pcaprub'])
    #  analyzer.permutations
    #  # => 2
    #   
    def redundant_gems(args = {})
      find_redundant_gems_with_gem(args)
      @count = 0
      @permutation_count = permutations
      @progress_bar = args[:progress_bar] || true
      gems = args[:gems] || @gems
      redundant = args[:redundant_gems] || @redundant_gems
      find_redundant_gems(args).empty? ? false : @redundant_gems
    end


    # Once we have figured out the redundant gems, we can easily check out
    # our optimized gem list which we can now use.
    #
    # == Typical Usage
    #
    #  analyzer = Resquire::Analyzer.new(:gems => ['packetfu', 'pcaprub'])
    #  analyzer.redundant_gems
    #  # => ['pcaprub']
    #  analyzer.optimized_gems
    #  # => ['packetfu']
    #   
    def optimized_gems
      optimized_gems = @gems.reject { |gem| @redundant_gems.include? gem }
      optimized_gems.empty? ? false : optimized_gems.uniq.sort
    end

    private

    # Used to find redundant gems.
    def find_redundant_gems(args = {})
      gems = @gems.reject { |gem| @redundant_gems.include? gem }
      permutation_count = permutations(gems)
      @count = 0
      # shuffle method by default
      shuffle = args[:shuffle] || true
      iterate = args[:iterate] || false
      if shuffle
        shuffle_permutations(args)   
      elsif iterate
        shuffle_permutations(args) 
      else
        iterate_permutations(args)
      end 
      @redundant_gems
    end

    # Help find redundant gems using the gem command.
    def find_redundant_gems_with_gem(args = {})
      gems = args[:gems] || @gems
      gems_with_deps = {}
      gems.each do |gem|
        output, status = Open3.capture2e("gem dependency #{gem}")
        next unless status.success?
        deps = output.split("\n").map(&:strip)
        deps = deps.reject { |g| g.include? ', development' or g.include? 'Gem ' }
        deps = deps.map { |x| x.gsub(/\s\(.+\)/, '') }
        gems_with_deps[gem] = deps
      end
      redundant_gems = []
      gems_with_deps.keys.each do |gem|
        next if gems_with_deps[gem].empty?
        gems_with_deps[gem].each do |g|
          redundant_gems << g if gems_with_deps.keys.include?(g)
        end
      end
      redundant_gems.uniq.each { |gem| @redundant_gems << gem unless @redundant_gems.include?(gem) }
      @redundant_gems
    end

    # We can shuffle the permutations, which can make things faster.
    def shuffle_permutations(args = {})
      gems = @gems.reject { |gem| @redundant_gems.include? gem }
      permutation_count = permutations(gems)
      count = 0
      gems = gems.permutation.to_a.shuffle
      template_location = File.dirname(Open3.capture2e("gem which resquire")[0]) + '/template.rb'
      gems.each do |gem_group|
        print "#{count}/#{permutation_count}\r" if @progress_bar
        redundant_gem, status = Open3.capture2e("ruby #{template_location} #{gem_group.join(',')}")
        @redundant_gems << redundant_gem unless status.success?
        break unless status.success?
        count += 1
      end
      find_redundant_gems(args) unless count == permutation_count
      @redundant_gems
    end

    # We can iterate over the permutations, which can make things faster.
    def iterate_permutations(args = {})
      gems = @gems.reject { |gem| @redundant_gems.include? gem }
      permutation_count = permutations(gems)
      count = 0
      template_location = File.dirname(Open3.capture2e("gem which resquire")[0]) + '/template.rb'
      gems.permutation.each do |gem_group|
        print "#{count}/#{permutation_count}\r" if @progress_bar
        redundant_gem, status = Open3.capture2e("ruby #{template_location} #{gem_group.join(',')}")
        @redundant_gems << redundant_gem unless status.success?
        break unless status.success?
        count += 1
      end
      find_redundant_gems(args) unless count == permutation_count
      @redundant_gems
    end
  end
end
