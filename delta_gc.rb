require 'newrelic_rpm'

puts ' String '.center(30, '-')

GC.start
initial_memory_usage = NewRelic::Agent::Samplers::MemorySampler.new.sampler.get_memory
string_inc = []
1_000_000.times do
  string_inc << "my string"
end

puts "Memory before GC: #{NewRelic::Agent::Samplers::MemorySampler.new.sampler.get_memory}, Delta: #{NewRelic::Agent::Samplers::MemorySampler.new.sampler.get_memory - initial_memory_usage}"

GC.start

puts "Memory after GC: #{NewRelic::Agent::Samplers::MemorySampler.new.sampler.get_memory}, Delta: #{NewRelic::Agent::Samplers::MemorySampler.new.sampler.get_memory - initial_memory_usage}"


puts ' Constant '.center(30, '-')

initial_memory_usage = NewRelic::Agent::Samplers::MemorySampler.new.sampler.get_memory
CONSTANT_INC = []
1_000_000.times do
  CONSTANT_INC << "my string"
end

puts "Memory before GC: #{NewRelic::Agent::Samplers::MemorySampler.new.sampler.get_memory}, Delta: #{NewRelic::Agent::Samplers::MemorySampler.new.sampler.get_memory - initial_memory_usage}"

GC.start

puts "Memory after GC: #{NewRelic::Agent::Samplers::MemorySampler.new.sampler.get_memory}, Delta: #{NewRelic::Agent::Samplers::MemorySampler.new.sampler.get_memory - initial_memory_usage}"
