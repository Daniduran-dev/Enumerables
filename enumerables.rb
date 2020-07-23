
module Enumerable
  def my_each
    return to_enum(:my_each) unless block_given?

    if is_a? Hash
      arr = to_a
      arr.size.times do |x|
        yield(arr[x][0], arr[x][1])
      end
    else
      size.times do |x|
        yield(to_a[x])
        self
      end
    end
    self
  end

  def my_each_with_index(value = 0)
    return to_enum(:my_each_with_index) unless block_given?

    index = value
    if is_a? Hash
      arr = to_a
      arr.size.times do |x|
        yield([arr[x][0], arr[x][1]], index)
        index += 1
      end
    else
      size.times do |x|
        yield(to_a[x], index)
        index += 1
      end
    end
    self
  end

  def my_select(arg = nil)
    return to_enum(:my_select) unless block_given? || !arg.nil?

    arr = []
    hash = {}

    if is_a? Hash
      my_each do |x, y|
        hash[x] = y if yield(x, y)
      end
    elsif !arg.nil?
      my_each do |x|
        arr.push(x) if arg(x)
      end
    else
      my_each do |x|
        arr.push(x) if yield(x)
      end
    end
    arr || hash
  end

  def my_all?(arg = nil)
    return false unless block_given? || arg.nil? == false || empty?

    if block_given?
      my_each do |x|
        return false unless yield(x)
      end
    elsif is_a? Hash
      my_each do |x, y|
        return false unless yield(x, y)
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
    elsif is_a? Hash
      my_each do |x, y|
        return true if yield(x, y)
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
      end
      false
    end
  end

  def my_none?(arg = nil, &block)
    !my_any?(arg, &block)
  end

  def my_count(arg = nil)
    counter = 0
    if arg.nil? == false
      if is_a? Hash
        my_each do |x, y|
          counter += 1 if arg == [x, y]
        end
      else
        my_each do |x|
          counter += 1 if x == arg
        end
      end
    elsif block_given? == true
      if is_a? Hash
        my_each do |x, y|
          counter += 1 if yield(x, y)
        end
      else
        my_each do |x|
          counter += 1 if yield(x)
        end
      end
    else
      my_each do |_x|
        counter += 1
      end
    end
    counter
  end

  # rubocop:enable Metrics/CyclomaticComplexity, Metrics/MethodLength
  def my_map(proc = nil)
    return to_enum(:my_map) unless block_given?

    arr = []
    if !proc.nil?
      if is_a? Hash
        my_each do |x, y|
          r = proc.call(x, y)
          arr.push(r)
        end
      else
        to_a.my_each do |x|
          r = proc.call(x)
          arr.push(r)
        end
      end
    elsif is_a? Hash
        my_each do |x, y|
          r = proc.call(x, y)
          arr.push(r)
        end
    else
        to_a.my_each do |x|
          r = yield(x)
          arr.push(r)
        end
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

# rubocop:enable Metrics/ModuleLength, Metrics/PerceivedComplexity, Metrics/MethodLength

def multiply_els(arg)
  arg.my_inject(:*)
end