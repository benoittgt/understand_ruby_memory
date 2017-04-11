require 'memory_profiler'

report_1 = MemoryProfiler.report do
  def get_me_directly
    File.read('1.txt')
  end
  100.times { get_me_directly }
end

report_2 = MemoryProfiler.report do
  ST = File.read('2.txt')
  def get_me_with_constant
    ST
  end
  100.times { get_me_with_constant }
end

report_3 = MemoryProfiler.report do
  ST_FREEZE = File.read('3.txt').freeze
  def get_me_with_constant_freeze
    ST_FREEZE
  end
  100.times { get_me_with_constant_freeze }
end

puts ' With get_me_directly '.center(50, '✨')
report_1.pretty_print
# Allocated String Report
# -----------------------------------
#        200  "1.txt"
#        200  memory_freeze_benchmark.rb:5
#
#        100  ""
#        100  memory_freeze_benchmark.rb:5
#
#
# Retained String Report
# -----------------------------------

puts "\n"
puts ' With get_me_with_constant '.center(50, '✨')
report_2.pretty_print
# Allocated String Report
# -----------------------------------
#          2  "2.txt"
#          2  memory_freeze_benchmark.rb:11
#
#          1  ""
#          1  memory_freeze_benchmark.rb:11
#
#
# Retained String Report
# -----------------------------------
#          1  ""
#          1  memory_freeze_benchmark.rb:11

puts "\n"
puts ' With get_me_with_constant_freeze '.center(50, '✨')
report_3.pretty_print
# Allocated String Report
# -----------------------------------
#          2  "3.txt"
#          2  memory_freeze_benchmark.rb:19
#
#          1  ""
#          1  memory_freeze_benchmark.rb:19
#
#
# Retained String Report
# -----------------------------------
#          1  ""
#          1  memory_freeze_benchmark.rb:19
