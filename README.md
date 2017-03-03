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
Memory before insert: 19.5546875 and initial_total_freed_objects: 320677
Memory before gc: 78.4765625, Delta: 58.9375, Objects freed before gc? 96
Memory after GC: 79.83984375, Delta: 60.28515625, Objects Freed after GC 219
---------- Constant ----------
Memory before insert: 79.84375 and initial_total_freed_objects: 320898
Memory before gc: 135.21484375, Delta: 55.375, Objeats freed before gc? 158
Memory after GC: 135.2890625, Delta: 55.4453125, Objects Freed after GC 266
```
