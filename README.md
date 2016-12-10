# Resquire

Reduce your redundant gem depenencies with resquire, which figures out which gems are redundant so you can require less gems for your ruby projects while still retaining the same functionality! By reducing redundant gems, you can make your application faster!

![David I of Scotland knighting a squire](https://upload.wikimedia.org/wikipedia/commons/3/3f/DavidI%26squire.jpg)

## Installation

While this gem is still in development, but when it's all done you'll be able to install it like so:

    $ gem install resquire

## Usage

```ruby
require "resquire"

# you can add gems when you create a new analyzer, as an array
analyzer = Resquire::Analyzer.new(:gems => ['colorize', 'packetfu', 'lolize'])

# you can also add gems individually
analyzer.add_gem('pcaprub')
# => true

# or as an array
analyzer.add_gems(['ipaddr', 'socket', 'thread'])
# => true

# we can check which gems the analyzer has to work with
analyzer.gems
# => ["colorize", "packetfu", "lolize", "pcaprub", "ipaddr", "socket", "thread"]

# quickly check ammount of permutations ( to see wtf we're about to get outselves into )
# no, srsly, like, you can easily have 20 gems; and that's 2,432,902,008,176,640,000 permutations dog, fo real 
# you can try splitting them up into smaller batches of roughly ~13
analyzer.permutations
# => 5040

# you can get an array of the redundant gems
analyzer.redundant_gems
# => ["pcaprub", "ipaddr", "socket", "thread"]

# you can choose not to shuffle the permutated array, may be better for larger gem groups
# since we're not pre-generating the permutations -- we're simply looping through the
# possibilities via an enumerator.
analyzer.redundant_gems(:shuffle => false) 
# => ["pcaprub", "ipaddr", "socket", "thread"]

# you can also choose to 

# or the new optimized gem listing as an array with the redundancies
analyzer.optimized_gems
# => ["colorize", "lolize", "packetfu"]
```

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

