# frozen_string_literal: true

require_relative '../enumerables.rb'
# rubocop: disable Metrics/BlockLength
describe 'Enumerable' do
  let(:array) { [1, 2, 3] }
  let(:array_string) { %w[ant bear cat] }
  let(:array_nil) { [nil, true, 99] }
  let(:array_numeric) { [1, 2i, 3.14] }
  let(:array_empty) { [] }
  let(:array_hash) { [a: 1, b: 2, c: 3] }

  describe '#my_each' do
    it 'returns each of the elements of the array if a block is given' do
      expect(array.my_each { |x| array_empty << x }).to eql(array_empty)
    end
    it 'returns an enumerator when no block given' do
      expect(array.my_each.class).to eql(Enumerator)
    end
  end

  describe '#my_each_with_index' do
    it 'returns each of the elements of the array with an index when a block is given' do
      array.my_each_with_index { |value, index| array_empty << value - index }
      expect(array_empty).to eql [1, 1, 1]
    end

    it 'returns an enumerator when no block given' do
      expect(array.my_each_with_index.class).to eql(Enumerator)
    end
  end

  describe '#my_select' do
    it 'returns an array of elements that accomplish the block condition when returns true' do
      expect(array.my_select { |x| x > 1 }).to eql([2, 3])
    end

    it 'returns an enumerator when no block given' do
      expect(array.my_select.class).to eql(Enumerator)
    end
  end

  describe '#my_all?' do
    it 'returns true when all elements accomplish the block condition true.' do
      expect(array_string.my_all? { |word| word.size > 3 }).to eql(false)
    end

    it 'returns false if there is no block or argument' do
      expect(array_nil.my_all?).to eql(false)
    end

    it 'returns true when all elements accomplish the argument' do
      expect(array_string.my_all?(/a/)).to eql(true)
    end
  end

  describe '#my_any?' do
    it 'returns true when any of the elements accomplish the block condition' do
      expect(array_string.my_any? { |word| word.size > 3 }).to eql(true)
    end

    it 'returns false if all values are false when no block given' do
      expect(array_nil.my_any?).to eql(true)
    end

    it 'returns true if any element is equal to the argument.' do
      expect(array_string.my_any?(/d/)).to eql(false)
    end
  end

  describe '#my_none?' do
    it 'returns true when none of elements accomplish the block condition' do
      expect(array_string.my_none? { |word| word.size > 3 }).to eql(false)
    end

    it 'returns false if an empty array is suplied' do
      expect(array_nil.my_none?).to eql(false)
    end

    it 'returns false if any element is absolutely equal to given pattern.matches the argument' do
      expect(array_string.my_none?(/d/)).to eql(true)
    end
  end

  describe '#my_count' do
    it 'returns the number of elements' do
      expect(array.my_count).to eql 3
    end

    it 'returns the number of elements that matches the argument' do
      expect(array.my_count(2)).to eql 1
    end

    it 'returns the number of elements that accomplish true in the condition given in the block' do
      expect(array.my_count(&:even?)).to eql 1
    end
  end

  describe '#my_map' do
    it 'returns a new array with the result of the block applied' do
      expect(array.my_map { |i| i + 1 }).to eql [2, 3, 4]
    end

    it 'returns an enumerator when no block given' do
      expect(array.my_map.class).to eql(Enumerator)
    end
  end

  describe '#my_inject' do
    context 'if accumulator is defined' do
      it 'returns the result of accumulator and elements by using the given operatorl' do
        expect((5..10).my_inject(2, :*)).to eql 302_400
      end

      it 'returns the result of accumulator and items by using given block' do
        expect((5..10).my_inject(2) { |product, n| product * n }).to eql 302_400
      end
    end

    context "if accumulator isn't defined" do
      it 'returns the result of elements by using the given operator' do
        expect((5..10).my_inject(:*)).to eql 151_200
      end

      it 'returns the result of elements by using the given block' do
        expect((5..10).my_inject { |sum, n| sum + n }).to eql 45
      end

      it 'returns the result of elements by using the given longest block' do
        expect(array_string.my_inject do |memo, word|
          memo.length > word.length ? memo : word
        end).to eql 'bear'
      end
    end
  end
end
# rubocop: enable Metrics/BlockLength
