require_relative '../enumerables.rb'

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
    it "returns enumerator if block isn't given." do
      expect(my_arr.my_each.class).to eql(Enumerator)
    end
  end
end
