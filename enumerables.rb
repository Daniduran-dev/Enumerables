module Enumerable

	def my_each
		return to_enum(:my_each) unless block_given?
		self.size.times do |x|
			yield(self[x])
		end
		return self
    end

    def my_each_with_index(value = 0)
        return to_enum(:my_each_with_index) unless block_given?
        index = value
        self.size.times do |x|
			yield(self[x], index)
            index += 1
		end    
    end

    def my_select(arg=nil)
        return to_enum(:my_select) unless block_given? || arg != nil
        arr = []
        
        if arg != nil
            self.my_each do |x|
                if arg(x)
                    arr.push(x)
                end
            end
        else
            self.my_each do |x|  
                if yield(x)
                    arr.push(x)
                end
            end
        end
        return arr
    end

    def my_all?(arg = nil)
        return false unless block_given? || arg.nil? == false || self.empty?
        
        if block_given?
            self.my_each do |x|
                return false unless yield(x)
            end
        elsif arg.class == Regexp
            self.my_each do |x|
                return false unless x.match(arg)
            end
        elsif arg.class == Numeric
            self.my_each do |x|
                return false unless  x.class === arg
            end 
        else 
            self.my_each do |x|
                return false unless arg === x
            end
        end        
        return true
    end
    

    def my_any?(arg = nil)
        return true if !block_given? && arg.nil? && !(self.select{ |x| x }).empty?
        return false unless block_given? || !arg.nil? 
        
        if block_given?
            self.my_each do |x|
                return true if yield(x) == true
            end
        elsif arg.class == Regexp
            self.my_each do |x|
                return true if x.match(arg)
            end
        elsif (arg.is_a? Numeric) || (arg.is_a? String)
          self.my_each do |x|
            return true if arg === x
          end      
        else 
          self.my_each do |x|
              return true if x.class == arg
          end
        end        
        return false
    end

    def my_none?(arg = nil, &block)
        !my_any?(arg, &block)
    end

    def my_count(arg = nil)
        counter = 0
        if arg.nil? == false
          self.my_each do |x|
            counter += 1 unless x != arg
          end
        elsif block_given? == true
          self.my_each do |x|
            if yield(x) == true
              counter += 1
            else
              counter += 0
            end
          end
        else
          self.my_each do |x|
            counter += 1
          end
        end
        return counter
    end

    def my_map(proc = nil)
        return to_enum(:my_map) unless block_given?
        arr = []
        if proc != nil
          self.to_a.my_each do |x|
            y = proc.call(x)
            arr.push(y)
          end
        else  
          self.to_a.my_each do |x|
            y = yield(x)
            arr.push(y)
          end
        end
        return arr
    end
    
end

puts 'my_each'

[1, 2, 3, 4, 'hi'].my_each do |x|
  puts x
end
p [2,4,7,11].my_each #<Enumerator: [2, 4, 7, 11]:my_each>

puts '-*-*-*-*-*-*-*-*-*-*-*-*-'
puts 'my_each_with_index'

[1, 2, 3, 4, 'hi'].my_each_with_index { |value, index| puts "#{value} => #{index}" }
[1, 2, 3, 4, 'hi'].my_each_with_index(5) { |value, index| puts "#{value} => #{index}" }
puts [2,4,7,11].my_each_with_index  #<Enumerator: [2, 4, 7, 11]:my_each_with_index

puts '-*-*-*-*-*-*-*-*-*-*-*-*-'
puts 'my_select'

result = [1, 2, 3, 4, 5, 6].select(&:even?) #=> [2, 4, 6]
puts result
puts "------------------------"
block = proc { |num| num = 11 }
puts [2,4,7,11].my_select(&block) #=> [11]
puts "-------------------------"
puts [2,4,7,11].my_select  #<Enumerator: [2, 4, 7, 11]:my_select>
puts [1, 2].my_select { |num| num == 1 } #=> [1]

puts '-*-*-*-*-*-*-*-*-*-*-*-*-'
puts 'my_all?'

puts %w[ant bear cat].my_all? { |word| word.length >= 3 } #=> true
puts "1-------------------"
puts %w[ant bear cat].my_all? { |word| word.length >= 4 } #=> false
puts "-2------------------"
puts %w[ant bear cat].my_all?(/t/) #=> false
puts "--3-----------------"
puts [1, 2i, 3.14].my_all?(Numeric) #=> true
puts "---4----------------"
puts [nil, true, 99].my_all? #=> false
puts "----5---------------"
puts [].my_all? #=> true
puts "-----6--------------"
puts [nil, false, true, []].my_all? #=> false
puts "------7-------------"
puts [1, 2.5, 'a', 9].my_all?(Integer) #=> false
puts "-------8------------"
puts %w[dog door rod blade].my_all?(/d/) #=> true
puts "--------9-----------"
puts [3,4,7,11].my_all?(3) #=> false
puts "---------10----------"
puts [1, false].my_all? #=> false

puts '-*-*-*-*-*-*-*-*-*-*-*-*-'
puts 'my_any??'
puts "1-------------------"
puts %w[ant bear cat].my_any? { |word| word.length >= 3 } #=> true
puts "-2------------------"
puts %w[ant bear cat].my_any? { |word| word.length >= 4 } #=> true
puts "--3-----------------"
puts %w[ant bear cat].my_any?(/d/) #=> false
puts "---4----------------"
puts [nil, true, 99].my_any?(Integer) #=> true
puts "----5---------------"
puts [nil, true, 99].my_any? #=> true
puts "-----6--------------"
puts [].my_any? #=> false
puts "------7-------------"
puts [nil, false, true, []].my_any? #=> true
puts "-------8------------"
puts [1, 2.5, 'a', 9].my_any?(Integer) #=> true
puts "--------9-----------"
puts %w[dog door rod blade].my_any?(/d/) #=> true
puts "---------10----------"
puts [3,4,7,11].my_any?(3) #=> true
puts "-----------11--------"
puts [1, false].my_any? #=> true
puts "-------------12------"
puts [1].my_any? #=> true
puts "---------------13----"
puts [nil].my_any? #=> false
puts "-----------------14--"
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