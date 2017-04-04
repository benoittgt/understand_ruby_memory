# Understand ruby memory usage 🤔

I initially made this blog post to add questions I have about ruby memory. I don't have any CS degree, never did some C, understanding how ruby memory use is not an easy path. I'm passionate about this subject.

## Questions

Here is a list of questions I have. Feel free to make a PR to answer them.

* Retained Vs Allocated: Does an object that is allocated can turn to be retained because he is still present after few GC ?

* What are the first line of heap dump that are not address ?
(Add exemple)
Partially answered from https://blog.codeship.com/the-definitive-guide-to-ruby-heap-dumps-part-i/

* Why when using a frozen string we don't allocate memory ?
I use a method because it represents "patterns" we discuss with my team, I try to measure the number of allocations betweens calling directly string, calling a string set into a constant outside the function and calling a string frozen in a constant outside the function.

```ruby
require 'memory_profiler'

report_1 = MemoryProfiler.report do
  def get_me_directly
    "hey"
  end
  get_me_directly
end

report_2 = MemoryProfiler.report do
  ST = "yep"
  def get_me_with_constant
    ST
  end
  get_me_with_constant
end

report_3 = MemoryProfiler.report do
  ST_FREEZE = "yop".freeze
  def get_me_with_constant_freeze
    ST_FREEZE
  end
  get_me_with_constant_freeze
end

report_1.pretty_print
# Allocated String Report
# -----------------------------------
#          1  "hey"
#          1  measure_allocation.rb:5
#
#
# Retained String Report
# -----------------------------------

report_2.pretty_print
# Allocated String Report
# -----------------------------------
#          1  "yep"
#          1  measure_allocation.rb:11
#
#
# Retained String Report
# -----------------------------------
#          1  "yep"
#          1  measure_allocation.rb:11

report_3.pretty_print
# Allocated String Report
# -----------------------------------
#
# Retained String Report
# -----------------------------------
```

> Manually inspecting this file might be of some interest, but we really need to aggregate information to make use of this data. Before we do that, let’s look at some of the keys in the generated JSON.
> * generation: The garbage collection generation where the object was generated
> * file: The file where the object was generated
> * line: The line number where the object was generated
> * address: This is the memory address of the object
> * memsize: The amount of memory the object consumes
> * references: The memory addresses of other objects that this object retains
> There are other keys, but that’s enough for now. It’s worth noting that several of these are optional. For example if an object was generated before you started tracing object allocations, it won’t contain generation, file, or line information.

* What is allocated and what is not allocated ?
  * strings    : yes
  * symbols    : ?
  * integer    : ?
  * boolean    : not
  * constant   : ?
  * freeze obj : ?

* What is garbage collected ?
  * strings    : yes
  * symbols    : ?
  * integer    : ?
  * boolean    : not
  * constant   : ?
  * freeze obj : ?

## Resources

Blog posts :
https://blog.codeship.com/the-definitive-guide-to-ruby-heap-dumps-part-i/
https://blog.codeship.com/the-definitive-guide-to-ruby-heap-dumps-part-ii/
http://www.be9.io/2015/09/21/memory-leak/
http://blog.skylight.io/hunting-for-leaks-in-ruby/
http://eng.rightscale.com/2015/09/16/how-to-debug-ruby-memory-issues.html
https://engineering.heroku.com/blogs/2015-02-04-incremental-gc/

Tools:
https://github.com/SamSaffron/memory_profiler
https://github.com/schneems/heap
https://github.com/tmm1/rbtrace
https://github.com/jondot/benchmark-ipsa
https://github.com/schneems/derailed_benchmarks/
https://github.com/tmm1/stackprof

Useful gist:
Finding a Ruby memory leak using a time analysis https://gist.github.com/wvengen/f1097651c238b2f7f11d

Learn with PR comments and ruby issues:
https://github.com/schneems/heap_problem/pull/1

Book :
Ruby under microscope
Rails perf guide

Videos:

And I would love to thanks especially Richard Schneems, Aaron Patterson, Sam Saffron...

