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

# then you can find out if there are any redundant gems to be found 
analyzer.redundant_gems?
# => true

# you can get an array of the redundant gems
analyzer.redundant_gems
# => ["pcaprub", "ipaddr", "socket", "thread"]

# or the new optimized gem listing as an array with the redundancies
analyzer.optimized_gems
# => ["colorize", "lolize", "packetfu"]
```

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

