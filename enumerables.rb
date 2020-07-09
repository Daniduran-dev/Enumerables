# rubocop:disable Metrics/ModuleLength, Style/IfInsideElse, Metrics/PerceivedComplexity, Metrics/MethodLength, Metrics/AbcSize,  Metrics/CyclomaticComplexity Metrics/CyclomaticComplexity,  Metrics/CyclomaticComplexity
module Enumerable
  def my_each
    return to_enum(:my_each) unless block_given?
    size.times do |x|
      yield(self[x])
    end
    self
  end

  def my_each_with_index(value = 0)
    return to_enum(:my_each_with_index) unless block_given?

    index = value
    size.times do |x|
      yield(self[x], index)
      index += 1
    end
  end

  def my_select(arg = nil)
    return to_enum(:my_select) unless block_given? || !arg.nil?

    arr = []

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

  def my_all?(arg = nil)
    return false unless block_given? || arg.nil? == false || empty?

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

  def my_any?(arg = nil)
    return true if !block_given? && arg.nil? && !(self.select { |x| x }).empty?
    return false unless block_given? || !arg.nil?

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
      endMetrics/AbcSize
    end
    false
  end

  def my_none?(arg = nil, &block)
    !my_any?(arg, &block)
  end

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

  def my_map(proc = nil)
    return to_enum(:my_map) unless block_given?

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
    else
      if !arg.nil? && !sym.nil?
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
    end
    acc
  end
end

def multiply_els(arg)
  arg.my_inject(:*)
end
# rubocop:enable Metrics/ModuleLength, Style/IfInsideElse, Metrics/PerceivedComplexity, Metrics/MethodLength, Metrics/AbcSize,  Metrics/CyclomaticComplexity Metrics/CyclomaticComplexity,  Metrics/CyclomaticComplexity