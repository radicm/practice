require_relative '../pascal_triangle'

RSpec.describe PascalTriangle do

  describe '#get_value_by_row_and_column' do
    it 'should return 1 for first row' do
      expect(described_class.get_value_by_row_and_column(0,0)).to eq(1)
    end
    it 'should return 10 for 50th row' do
      expect(described_class.get_value_by_row_and_column(5,3)).to eq(10)
    end
    it 'should return 85900584 for 50th row' do
      expect(described_class.get_value_by_row_and_column(49,7)).to eq(85900584)
    end
  end

  describe '#get_value_by_row_and_column' do
    it 'should return 1 for first layer' do
      expect(described_class.get_pyramid_x_y_row_value(0,0,0)).to eq(1)
    end
    it 'should return 10 for 5th row, 5th, column, 3rd row' do
      expect(described_class.get_pyramid_x_y_row_value(5,3,2)).to eq(100)
    end
    it 'should return 760874499 for 30th row, 7th, column, 5rd row' do
      expect(described_class.get_pyramid_x_y_row_value(99,2,3)).to eq(760874499)
    end
  end

end
