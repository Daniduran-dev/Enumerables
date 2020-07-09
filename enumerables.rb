# rubocop:disable Metrics/ModuleLength
module Enumerable
  def my_each
    return to_enum(:my_each) unless block_given?
​
    size.times do |x|
      yield(self[x])
    end
    self
  end
​
  def my_each_with_index(value = 0)
    return to_enum(:my_each_with_index) unless block_given?
​
    index = value
    size.times do |x|
      yield(self[x], index)
      index += 1
    end
  end
​
  def my_select(arg = nil)
    return to_enum(:my_select) unless block_given? || !arg.nil?
​
    arr = []
​
    if !arg.nil?
      my_each do |x|
        arr.push(x) if arg(x)
      end
    else
      my_each do |x|
        arr.push(x) if yield(x)
      end
    end
    arr
  end
​
  # rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
  def my_all?(arg = nil)
    return false unless block_given? || arg.nil? == false || empty?
​
    if block_given?
      my_each do |x|
        return false unless yield(x)
      end
    elsif arg.class == Regexp
      my_each do |x|
        return false unless x.match(arg)
      end
    elsif arg.class == Numeric
      my_each do |x|
        return false unless x.class == arg
      end
    else
      my_each do |x|
        return false unless arg == x
      end
    end
    true
  end
​
  def my_any?(arg = nil)
    return true if !block_given? && arg.nil? && !(self.select { |x| x }).empty?
    return false unless block_given? || !arg.nil?
​
    if block_given?
      my_each do |x|
        return true if yield(x) == true
      end
    elsif arg.class == Regexp
      my_each do |x|
        return true if x.match(arg)
      end
    elsif (arg.is_a? Numeric) || (arg.is_a? String)
      my_each do |x|
        return true if arg == x
      end
    else
      my_each do |x|
        return true if x.class == arg
​
        endMetrics / AbcSize
      end
      false
    end
  end
​
  # rubocop:enable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
  def my_none?(arg = nil, &block)
    !my_any?(arg, &block)
  end
​
  def my_count(arg = nil)
    counter = 0
    if arg.nil? == false
      my_each do |x|
        counter += 1 unless x != arg
      end
    elsif block_given? == true
      my_each do |x|
        counter += if yield(x) == true
                     1
                   else
                     0
                   end
      end
    else
      my_each do |_x|
        counter += 1
      end
    end
    counter
  end
​
  def my_map(proc = nil)
    return to_enum(:my_map) unless block_given?
​
    arr = []
    if !proc.nil?
      to_a.my_each do |x|
        y = proc.call(x)
        arr.push(y)
      end
    else
      to_a.my_each do |x|
        y = yield(x)
        arr.push(y)
      end
    end
    arr
  end
​
  # rubocop:disable Metrics/PerceivedComplexity
  def my_inject(arg = nil, sym = nil)
    arr = to_a
    if block_given?
      if !arg.nil?
        acc = arg
        arr.my_each do |x|
          acc = yield(acc, x)
        end
      else
        acc = arr[0]
        arr[1..arr.length - 1].my_each do |x|
          acc = yield(acc, x)
        end
      end
    elsif !arg.nil? && !sym.nil?
      acc = arg
      arr.my_each do |x|
        acc = acc.send(sym, x)
      end
    elsif arg.class == Symbol
      acc = arr[0]
      arr[1..arr.length - 1].my_each do |x|
        acc = acc.send(arg, x)
      end
    end
    acc
  end
end
​
# rubocop:enable Metrics/ModuleLength, Metrics/PerceivedComplexity
​
def multiply_els(arg)
  arg.my_inject(:*)
end

puts 'my_each'

[1, 2, 3, 4, 'hi'].my_each do |x|
  puts x
end
puts [2,4,7,11].my_each #<Enumerator: [2, 4, 7, 11]:my_each>

puts '-*-*-*-*-*-*-*-*-*-*-*-*-'
puts 'my_each_with_index'

[1, 2, 3, 4, 'hi'].my_each_with_index { |value, index| puts "#{value} => #{index}" }
puts [2,4,7,11].my_each_with_index  #<Enumerator: [2, 4, 7, 11]:my_each_with_index

puts '-*-*-*-*-*-*-*-*-*-*-*-*-'
puts 'my_select'

result = [1, 2, 3, 4, 5, 6].select(&:even?) #=> [2, 4, 6]
puts result
block = proc { |num| num = 11 }
puts [2,4,7,11].my_select(&block) #=> [11]
puts [2,4,7,11].my_select  #<Enumerator: [2, 4, 7, 11]:my_select>
puts [1, 2].my_select { |num| num == 1 } #=> [1]

puts '-*-*-*-*-*-*-*-*-*-*-*-*-'
puts 'my_all?'

puts %w[ant bear cat].my_all? { |word| word.length >= 3 } #=> true
puts %w[ant bear cat].my_all? { |word| word.length >= 4 } #=> false
puts %w[ant bear cat].my_all?(/t/) #=> false
puts [1, 2i, 3.14].my_all?(Numeric) #=> true
puts [nil, true, 99].my_all? #=> false
puts [].my_all? #=> true
puts [nil, false, true, []].my_all? #=> false
puts [1, 2.5, 'a', 9].my_all?(Integer) #=> false
puts %w[dog door rod blade].my_all?(/d/) #=> true
puts [3,4,7,11].my_all?(3) #=> false
puts [1, false].my_all? #=> false

puts '-*-*-*-*-*-*-*-*-*-*-*-*-'
puts 'my_any??'

puts %w[ant bear cat].my_any? { |word| word.length >= 3 } #=> true
puts %w[ant bear cat].my_any? { |word| word.length >= 4 } #=> true
puts %w[ant bear cat].my_any?(/d/) #=> false
puts [nil, true, 99].my_any?(Integer) #=> true
puts [nil, true, 99].my_any? #=> true
puts [].my_any? #=> false
puts [nil, false, true, []].my_any? #=> true
puts [1, 2.5, 'a', 9].my_any?(Integer) #=> true
puts %w[dog door rod blade].my_any?(/d/) #=> true
puts [3,4,7,11].my_any?(3) #=> true
puts [1, false].my_any? #=> true
puts [1].my_any? #=> true
puts [nil].my_any? #=> false
puts [nil, false, nil, false].my_any? #=> false

puts '-*-*-*-*-*-*-*-*-*-*-*-*-'
puts 'my_none?'

puts %w[ant bear cat].my_none? { |word| word.length == 5 } #=> true
puts %w[ant bear cat].my_none? { |word| word.length >= 4 } #=> false
puts %w[ant bear cat].my_none?(/d/) #=> true
puts [1, 3.14, 42].my_none?(Float) #=> false
puts [].my_none? #=> true
puts [nil].my_none? #=> true
puts [nil, false].my_none? #=> true
puts [nil, false, true].my_none? #=> false
puts [nil, false, true, []].my_none? #=> false
puts [1, 2.5, 'a', 9].my_none?(Integer) #=> false
puts %w[dog door rod blade].my_none?(/d/) #=> false
puts [3,4,7,11].my_none?(3) #=> false

puts '-*-*-*-*-*-*-*-*-*-*-*-*-'
puts 'my_count'

ary = [1, 2, 4, 2]
puts ary.my_count #=> 4
puts ary.my_count(2) #=> 2
puts ary.my_count(&:even?) #=> 3

puts '-*-*-*-*-*-*-*-*-*-*-*-*-'
puts 'my_map'

puts (1..4).my_map { |i| i * i } #=> [1, 4, 9, 16]
puts (1..4).my_map { 'dog' } #=> ["dog", "dog", "dog", "dog"]
puts %w[a b c].my_map(&:upcase) #=> ["A", "B", "C"]
puts %w[a b c].my_map(&:class) #=> [String, String, String]
puts [2,4,7,11].my_map #<Enumerator: [2, 4, 7, 11]:my_map
my_proc = Proc.new {|num| num > 10 }
puts [18, 22, 5, 6] .my_map(my_proc) {|num| num < 10 } # true true false false

puts '-*-*-*-*-*-*-*-*-*-*-*-*-'
puts 'my_inject'

longest = %w[cat sheep bear].my_inject do |memo, word|
  memo.length > word.length ? memo : word
end

puts longest #=> "sheep"

puts (5..10).my_inject { |sum, n| sum + n } #=> 45
puts (5..10).my_inject(2) { |sum, n| sum + n } #=> 47
puts (1..5).my_inject(4) { |prod, n| prod * n } #=> 480
puts [1, 1, 1].my_inject(:+) #=> 3
puts [1, 1, 1].my_inject(2, :+) #=> 5

puts '-*-*-*-*-*-*-*-*-*-*-*-*-'
puts 'multiply_els'

puts multiply_els([2, 4, 5]) #=> 40