# Understand ruby GC

Trying to understand GC effect using [NewRelic MemorySampler](https://github.com/newrelic/rpm/blob/492665dd73662ca3901735971127b1307e254637/lib/new_relic/agent/samplers/memory_sampler.rb#L113).

### Code 
```ruby
require 'newrelic_rpm'

puts ' String '.center(30, '-')

GC.start
initial_memory_usage = NewRelic::Agent::Samplers::MemorySampler.new.sampler.get_memory
initial_total_freed_objects = GC.stat(:total_freed_objects)
puts "Memory before insert: #{initial_memory_usage} and initial_total_freed_objects: #{initial_total_freed_objects}"

string_inc = []
1_000_000.times do
  string_inc << "my string"
end

puts "Memory before gc: #{NewRelic::Agent::Samplers::MemorySampler.new.sampler.get_memory}, \
Delta: #{NewRelic::Agent::Samplers::MemorySampler.new.sampler.get_memory - initial_memory_usage}, \
Objects freed before gc? #{GC.stat(:total_freed_objects) - initial_total_freed_objects}"

GC.start

puts "Memory after GC: #{NewRelic::Agent::Samplers::MemorySampler.new.sampler.get_memory}, \
Delta: #{NewRelic::Agent::Samplers::MemorySampler.new.sampler.get_memory - initial_memory_usage}, \
Objects Freed after GC #{GC.stat(:total_freed_objects) - initial_total_freed_objects}"

puts ' Constant '.center(30, '-')

initial_memory_usage = NewRelic::Agent::Samplers::MemorySampler.new.sampler.get_memory
initial_total_freed_objects = GC.stat(:total_freed_objects)
puts "Memory before insert: #{initial_memory_usage} and initial_total_freed_objects: #{initial_total_freed_objects}"

CONSTANT_INC = []
1_000_000.times do
  CONSTANT_INC << "my string"
end

puts "Memory before gc: #{NewRelic::Agent::Samplers::MemorySampler.new.sampler.get_memory}, \
Delta: #{NewRelic::Agent::Samplers::MemorySampler.new.sampler.get_memory - initial_memory_usage}, \
Objeats freed before gc? #{GC.stat(:total_freed_objects) - initial_total_freed_objects}"

GC.start

puts "Memory after GC: #{NewRelic::Agent::Samplers::MemorySampler.new.sampler.get_memory}, \
Delta: #{NewRelic::Agent::Samplers::MemorySampler.new.sampler.get_memory - initial_memory_usage}, \
Objects Freed after GC #{GC.stat(:total_freed_objects) - initial_total_freed_objects}"
```

### Result


```sh
$ ruby delta_gc.rb
----------- String -----------
Memory before GC: 78.5859375, Delta: 58.8828125
Memory after GC: 79.93359375, Delta: 60.22265625
---------- Constant ----------
Memory before GC: 135.44921875, Delta: 55.5390625
Memory after GC: 135.5546875, Delta: 55.62109375
```
