# Understand ruby memory usage 🤔

I initially made this blog post to add questions I have about ruby memory (in MRI). I don't have any CS degree, never did some C, understanding how ruby use memory is not an easy path. I'm passionate about this subject.

I will add more questions in the future using pull requests so feel free to watch the repo.

**Make a PR if you want to add links, answer to a question, or simply correct what I said. I would love that.** ✨

## Questions

* [Does an object that is allocated can turn to be retained because he is still present after few GC **[Answered]**?](https://github.com/benoittgt/understand_ruby_memory#does-an-object-that-is-allocated-can-turn-to-be-retained-because-he-is-still-present-after-few-gc-answered-)
* [What are the first line of a heap dump that are not address **[Answered]** ?](https://github.com/benoittgt/understand_ruby_memory#what-are-the-first-line-of-a-heap-dump-that-are-not-address-answered-)
* [What is allocated and what is not allocated **[Partially answered]** ?](https://github.com/benoittgt/understand_ruby_memory#partially-answered-what-is-allocated-and-what-is-not-allocated-not-every-object-requires-allocation)
* [What is garbage collected **[Not answered]** ?](https://github.com/benoittgt/understand_ruby_memory#what-is-garbage-collected-)
* [Why people are always scared about time spent in GC when the Newrelic graph of my app show an average time spent in GC that is 0.0676% **[Answered]** ?](https://github.com/benoittgt/understand_ruby_memory#why-people-are-always-scared-about-time-spent-in-gc-when-the-newrelic-graph-of-my-app-show-an-average-time-spent-in-gc-that-is-00676-)
* [Why when using a frozen string we don't allocate memory **[Answered]** ?](https://github.com/benoittgt/understand_ruby_memory#why-when-using-a-frozen-string-we-dont-allocate-memory-)
* [Why generation number in heap dump are in random order **[Not answered]** ?](https://github.com/benoittgt/understand_ruby_memory#why-generation-number-in-heap-dump-are-in-random-order-)

---

#### Does an object that is allocated can turn to be retained because he is still present after few GC **[Answered]** ? 

  From (["retained" vs "allocated" from memory_profiler README](https://github.com/SamSaffron/memory_profiler/blob/master/README.md))

  Yes. The term "allocated" vs "retained" may vary depending on the tool you use, but, for example, in `memory_profiler`, "retained" means "survived a major GC".

#### What are the first line of a heap dump that are not address **[Answered]** ?

  Header of the heap dump [from heapy gem](https://github.com/schneems/heapy/tree/master/spec/fixtures/dumps) (carefull is 78mo text file)

   ```ruby
  {"type":"ROOT", "root":"vm", "references":["0x7fb4740bc400", "0x7fb4740b79a0", "0x7fb4740dff68", "0x7fb4740bff60", "0x7fb4740bff10", "0x7fb474c13a88", "0x7fb474ac0618", "0x7fb4740bfe98", "0x7fb4740bfe70", "0x7fb4740ddc68", "0x7fb4740dff90", "0x7fb4772f88d8", "0x7fb4772f8900"]}
  {"type":"ROOT", "root":"finalizers", "references":["0x7fb4768584c8", "0x7fb474f18a58", "0x7fb477083ad0", "0x7fb4739cd040", "0x7fb4772c99c0", "0x7fb475fa9188", "0x7fb475e00368", "0x7fb475d99320"]}
  {"type":"ROOT", "root":"machine_context", "references":["0x7fb474027760", "0x7fb474027350", "0x7fb4740bed18", "0x7fb4740becc8", "0x7fb4740bed18", "0x7fb4772f8900", "0x7fb4740ddc68", "0x7fb474027850", "0x7fb474027850", "0x7fb4740becc8", "0x7fb4740becc8", "0x7fb4740becc8", "0x7fb475dc0ab0", "0x7fb476ab2458", "0x7fb4740bfd58", "0x7fb4740bfd58", "0x7fb4740bfd58", "0x7fb4740ddc68", "0x7fb475dc0b78", "0x7fb4768919f8", "0x7fb4740ddc68", "0x7fb4738e33c8", "0x7fb4740ddc68", "0x7fb4740ddc68", "0x7fb4740ddc68", "0x7fb4740dec58", "0x7fb4740dec58", "0x7fb4740ddc68", "0x7fb4740dec58", "0x7fb475dc26d0", "0x7fb475dc26d0", "0x7fb475dc26d0", "0x7fb4740bfd58", "0x7fb475dc26d0", "0x7fb475dc0808", "0x7fb47587d828", "0x7fb4740deca8", "0x7fb4740bfd58", "0x7fb4740bfd58", "0x7fb4740bfd58", "0x7fb4738e33c8", "0x7fb4738ed0d0", "0x7fb475dc23b0", "0x7fb475dc0b78", "0x7fb475dc23b0", "0x7fb475dc23b0", "0x7fb4772f99b8", "0x7fb475dc23b0", "0x7fb4772f99b8", "0x7fb475dc2360", "0x7fb476862d38", "0x7fb475dc26d0", "0x7fb475dc2360", "0x7fb4740cd980", "0x7fb475dc2360", "0x7fb4772f9800", "0x7fb4772f9828", "0x7fb4772f9828", "0x7fb4740dced0", "0x7fb4740cd980", "0x7fb4740cd980", "0x7fb4740cd980", "0x7fb475dc23b0", "0x7fb476862d38", "0x7fb475dc0f88", "0x7fb475de8268", "0x7fb475de83f8", "0x7fb4740ddc68", "0x7fb4740dec58", "0x7fb475de8268", "0x7fb475de83d0", "0x7fb475df1bb0", "0x7fb475de83f8", "0x7fb475df1bb0", "0x7fb4740ddc68", "0x7fb475df1c50", "0x7fb4740ddc68", "0x7fb475df1bd8", "0x7fb4740ddc68", "0x7fb4740deaf0", "0x7fb4740ddc68", "0x7fb476988a28", "0x7fb476988a00", "0x7fb476988d98", "0x7fb476988d98", "0x7fb476988a00", "0x7fb4740deaf0", "0x7fb4740ddc40", "0x7fb4740ddc40", "0x7fb4740bc338", "0x7fb47490a2b0", "0x7fb4740ddc68", "0x7fb47698ac88", "0x7fb47698ac88", "0x7fb47698ac88", "0x7fb47698ac88", "0x7fb47698ac88"]}
  {"type":"ROOT", "root":"global_list", "references":["0x7fb4759d3678", "0x7fb4759d3768", "0x7fb4759d3790", "0x7fb4759d37e0", "0x7fb4759d3808", "0x7fb4759d3830", "0x7fb4759d38d0", "0x7fb4759d3920", "0x7fb4759d3970", "0x7fb4759d3998", "0x7fb4759d39e8", "0x7fb4759d3a10", "0x7fb4759d3a38", "0x7fb4759d3a88", "0x7fb4759d3ab0", "0x7fb4759d3ad8", "0x7fb4759d3b00", "0x7fb4759d3b28", "0x7fb4759d3b78", "0x7fb4759d3ba0", "0x7fb4759d3bc8", "0x7fb4759d3bf0", "0x7fb4759d3c18", "0x7fb4759d3c40", "0x7fb4759d3c68", "0x7fb4759d3c90", "0x7fb4759d3cb8", "0x7fb4759d3ce0", "0x7fb4759d3d58", "0x7fb4759d3dd0", "0x7fb4759d3df8", "0x7fb4759d3e20", "0x7fb4759d3e70", "0x7fb4759d3ee8", "0x7fb4759d3f10", "0x7fb4759d3fb0", "0x7fb474135fa8", "0x7fb4741353c8", "0x7fb474134270", "0x7fb474134298", "0x7fb4741342c0", "0x7fb4741342e8", "0x7fb474134310", "0x7fb474134338", "0x7fb474134360", "0x7fb474134388", "0x7fb4741343b0", "0x7fb4741343d8", "0x7fb474134428", "0x7fb474134450", "0x7fb474134478", "0x7fb4741344a0", "0x7fb4741344c8", "0x7fb4741344f0", "0x7fb474134518", "0x7fb474134540", "0x7fb474134568", "0x7fb474134590", "0x7fb474134608", "0x7fb47481da50", "0x7fb47481dac8", "0x7fb47481db40", "0x7fb47481db68", "0x7fb47481dd20", "0x7fb47481dd98", "0x7fb47481dfa0", "0x7fb47481dfc8", "0x7fb47481e018", "0x7fb47481e040", "0x7fb47481e248", "0x7fb47481e388", "0x7fb47481e5e0", "0x7fb47481e608", "0x7fb47481e6a8", "0x7fb47481e770", "0x7fb47481e7e8", "0x7fb47481e8d8", "0x7fb47481e928", "0x7fb47481e9c8", "0x7fb47481ea40", "0x7fb47481eae0", "0x7fb47481ec48", "0x7fb47481ed88", "0x7fb47481ee28", "0x7fb47481ee50", "0x7fb47481f058", "0x7fb47481f0d0", "0x7fb47481f0f8", "0x7fb47481f210", "0x7fb47481f288", "0x7fb47481f378", "0x7fb47481f418", "0x7fb47481f440", "0x7fb47481f4b8", "0x7fb47481f508", "0x7fb47481f710", "0x7fb47481f738", "0x7fb47481f760", "0x7fb47481fad0", "0x7fb47481fb20", "0x7fb47481fb70", "0x7fb47481fbe8", "0x7fb47584f270", "0x7fb475874700", "0x7fb475874a20", "0x7fb4769904d0", "0x7fb4740dff40"]}
  ```

  *Answer by Aaron Patterson https://github.com/benoittgt/understand_ruby_memory/issues/1*

  > Those are "ROOTS" (the ones with type = "ROOTS").  The system has various "roots".

  > #### What is a "ROOT"?

  > Objects in the system form a tree data structure.  Imagine some code like this:

  ```ruby
  a = "foo"
  b = "bar"
  c = { a => b }
  ```

  > It's easy to see how `c` is connected to `a` and `b` and prevents them from being garbage collected:

  ![abc](http://imgur.com/Rcc08c2.png)

  > But say we have this:

  ```ruby
  a = "foo"
  b = "bar"
  c = { a => b }
  GC.start
  p c
  ```

  > What prevents `c` from being garbage collected?  Something must hold a reference to `c` so that the garbage collector can know that it shouldn't be GC'd.  This is where ROOTS come in.  Roots are special nodes in the system that hold on to these references:

  ![roots](http://imgur.com/5OhGzvI.png)

  > MRI has a few different places it considers a root, and those are in the name `root` (like `vm`, `finalizers`, etc).  Explaining each of these types is a little too long for here, but you can think of them as the root of the tree that forms your object graph.  They keep your program objects alive, and they are the starting point for the GC to find live objects in your system.  In fact the graph I showed above is a little inaccurate.  Since `a` and `b` are also top level local variables like `c`, the graph looks a bit more like this:

  ![total](http://imgur.com/P7JFgN8.png)

  > Hope that helps!

-----

  For the rest of the dump. Go to https://blog.codeship.com/the-definitive-guide-to-ruby-heap-dumps-part-i/ but not the header.

  > Manually inspecting this file might be of some interest, but we really need to aggregate information to make use of this data. Before we do that, let’s look at some of the keys in the generated JSON.
  > * generation: The garbage collection generation where the object was generated
  > * file: The file where the object was generated
  > * line: The line number where the object was generated
  > * address: This is the memory address of the object
  > * memsize: The amount of memory the object consumes
  > * references: The memory addresses of other objects that this object retains
  > There are other keys, but that’s enough for now. It’s worth noting that several of these are optional. For example if an object was generated before you started tracing object allocations, it won’t contain generation, file, or line information.

#### What is allocated and what is not allocated ([*Not every object requires allocation*](https://youtu.be/gtQmWk8mCRs?list=PLXvaGTBVk36uIVBGKI72vqd9BFcMmPFI7&t=1869)) **[Partially answered]** ?

  The list is a mix of "types" that may be not clear enough

| 🌚 | allocated?  |
|----------------|-------------|
| integers | no |
| booleans | no |
| nil | no |
| strings | yes |
| symbols | yes |
| constants | yes |
| freeze objects | yes |
| arrays | yes |
| hashes | yes |
| what else? | ? |

#### What is garbage collected ?

| 🐕 | garbage collected?  |
|----------------|-------------|
| integers | no |
| booleans | no |
| nil | no |
| strings | yes |
| symbols | [it depends?](https://www.sitepoint.com/symbol-gc-ruby-2-2/) |
| constants | *If you remove a constant, the object it points to will be GC'd. But constants aren't really a type of object, it's just a name.* [source](https://github.com/benoittgt/understand_ruby_memory/issues/2) |
| freeze objects | yes |
| arrays | yes |
| hashes | yes |
| what else? | ? |

#### Why people are always scared about time spent in GC when the Newrelic graph of my app show an average time spent in GC that is 0.0676% ?

[Nate Berkopec's opinion](https://github.com/benoittgt/understand_ruby_memory/pull/5) - most people *assume* garbage collection takes a lot of time in a GC'd language. GC languages are slower than non-GC'd languages, therefore it must be GC that is slow. However, it's not just *GC* but *allocation* and the record keeping that goes along with it that slows Ruby programs. Creating an object isn't just the simple process of writing to some memory location, we have to do a bunch of checks, look for free space in the ObjectSpace, etc etc. So a GC'd language *is* slower, but we actually incur most of the cost *while running the program*, not *when garbage collecting*.

#### Why when using a frozen string we don't allocate memory **[Answered]** ?
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
  
  As [mentionned by Sam Saffron](https://github.com/benoittgt/understand_ruby_memory/pull/5#issuecomment-293259216) it can happen when :
  
  > it was allocated earlier when the ruby code was parsed. You can confirm this by loading a file and putting the load in a mem profiler block.
  
  Check and updated benchmark that doesn't show this weird behavior : https://github.com/benoittgt/understand_ruby_memory/blob/master/memory_freeze_benchmark.rb
  
#### Why generation number in heap dump are in random order ?

  When you read heap dump you have lines like this :
  ```ruby
  {"address":"0x7fb27108e3e8", "type":"IMEMO", "class":"0x7fb26aa79cd8", "references":["0x7fb26aa7aa20", "0x7fb26aa7b0b0", "0x7fb26aa7a9d0"], "file":"/Users/bti/.rvm/gems/ruby-2.3.0/gems/activerecord-4.2.5.2/lib/active_record/attributes.rb", "line":106, "method":"reset_column_information", "generation":53, "memsize":40, "flags":{"wb_protected":true, "old":true, "uncollectible":true, "marked":true}}
  ```
  We can read on [How I spent two weeks hunting a memory leak](http://www.be9.io/2015/09/21/memory-leak/) that:
  > you can enable object creation tracing, and for each newly created object the location where it was instantiated (source file, line) will be saved and accessible later.

  I generated a heap dump for few requests on a Rails app... and extract generation number in the dump with `jq`.
  ```sh
  $ cat tmp/2017-04-10T19:32:45+02:00-heap.dump | jq 'select(.generation != null) | "\(.generation) "' -j
  ... 57 57 57 57 58 51 58 58 58 58 58 51 58 58 58 58 58 58 51 58 58 58 58 58 51 58 51 51 51 51 51 51 51 51 51 51 ...
  ```
  As you can see generation number are in random order. I don't understand why. 

  I read [Watching and Understanding the Ruby 2.1 Garbage Collector at Work](https://thorstenball.com/blog/2014/03/12/watching-understanding-ruby-2.1-garbage-collector/) and [Tracing garbage collection](https://en.wikipedia.org/wiki/Tracing_garbage_collection#Generational_GC_.28ephemeral_GC.29) without finding the answer.

Other questions will follow

---

## Resources

#### Blog post, gist, google doc :
* The Definitive Guide to Ruby Heap Dumps by Richard Schneems ([part 1](https://blog.codeship.com/the-definitive-guide-to-ruby-heap-dumps-part-i/), [part 2](https://blog.codeship.com/the-definitive-guide-to-ruby-heap-dumps-part-ii/))
* [How I spent two weeks hunting a memory leak in Ruby by Oleg Dashevskii](http://www.be9.io/2015/09/21/memory-leak/)
* [What I Learned About Hunting Memory Leaks in Ruby 2.1 by Peter Wagenet](http://blog.skylight.io/hunting-for-leaks-in-ruby/)
* [How to debug Ruby memory issues by Callum Dryden](http://eng.rightscale.com/2015/09/16/how-to-debug-ruby-memory-issues.html)
* [Incremental Garbage Collection in Ruby 2.2 by Koichi Sasada](https://engineering.heroku.com/blogs/2015-02-04-incremental-gc/)
* [Ruby Hacking Guide by many good people](https://ruby-hacking-guide.github.io/)
* [Demystifying the Ruby GC by Sam Saffron](https://samsaffron.com/archive/2013/11/22/demystifying-the-ruby-gc)
* [Finding a Ruby memory leak using a time analysis by wvengen](https://gist.github.com/wvengen/f1097651c238b2f7f11d)
* [Google doc with Ruby memory Model](https://docs.google.com/document/d/1pVzU8w_QF44YzUCCab990Q_WZOdhpKolCIHaiXG-sPw/edit#heading=h.gh0cw4u6nbi5)
* [Ruby 2.2.X AWS SDK memory leak by Johan Lundahl](https://gist.github.com/quezacoatl/7657854f371edcb5d8e6)
* [Ruby 2.1: objspace.so by Aman Gupta](http://tmm1.net/ruby21-objspace/)
* [Ruby Under The Hood: Memory Layout of an Object by	Jesus Castello](http://www.blackbytes.info/2017/04/memory-layout-of-an-object/)

#### Tools:
* https://github.com/SamSaffron/memory_profiler
* https://github.com/schneems/heapy
* https://github.com/tmm1/rbtrace
* https://github.com/jondot/benchmark-ipsa
* https://github.com/schneems/derailed_benchmarks/
* https://github.com/tmm1/stackprof
* http://tenderlove.github.io/heap-analyzer/
* https://github.com/michaelherold/benchmark-memory
* https://github.com/ko1/allocation_tracer/
* https://github.com/srawlins/allocation_stats

#### Learn with PR comments and ruby issues:
* [Demonstrates that a non-retained object is sometimes still present in the heap](https://github.com/schneems/heap_problem/pull/1)
* [Documenting Ruby memory model](https://bugs.ruby-lang.org/issues/12020)
* [Decreased Object Allocation in Pathname.rb](https://bugs.ruby-lang.org/issues/11375)
* [Derailed benchmark explanations](https://github.com/schneems/derailed_benchmarks/issues/62)

#### Book :
* [Ruby under microscope](http://patshaughnessy.net/ruby-under-a-microscope)
* [Rails speed book](https://www.railsspeed.com/)

#### Videos:

Youtube video playlist : https://www.youtube.com/playlist?list=PLXvaGTBVk36uIVBGKI72vqd9BFcMmPFI7

##### Other than youtube :
* [GoRuCo 2010 - Aman Gupta - memprof: the ruby level memory profiler](https://vimeo.com/12748731)

## Tanks 💕
And I would love to thanks especially Richard Schneems, Aaron Patterson, Sam Saffron...
