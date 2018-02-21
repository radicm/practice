class PascalTriangle

  # REFERENCE for more info visit https://www.mathsisfun.com/pascals-triangle.html

  # (0) 1             -> (a)
  # (1) 1,1           -> (a), (b)
  # (2) 1,2,1         -> (aa), (ab, ba), (bb)
  # (3) 1,3,3,1       -> (aaa), (aab, aba, baa), (abb, bab, bba), (bbb)
  # (4) 1,4,6,4,1     -> (aaaa), (aaab, aaba, abaa, baaa), (aabb, abab, abba, baba, bbaa), (baaa, abaa, aaba, aaab), (bbbb)
  #    (0).(2).(4)

  # triangle row values are permutations without repetition
  # value = n! / r!*(n-r)! where n -> row and r -> column

  # @param [Integer] row
  # @param [Integer] column (0..row-1)
  # @return [Integer]
  def self.get_value_by_row_and_column(row, column)
    fact(row) / (fact(column) * fact(row - column))
  end

  # row x,y
  # (0) (0) 1       ->   1

  # (1) (0) 1 1     ->  1  n
  #     (1) 1 1     ->  n n*n

  # (2) (0) 1 2 1   ->  1  n   x
  #     (1) 2 4 2   ->  n n*n n*x
  #     (2) 1 2 1   ->  x n*x x*x

  # (3) (0) 1 3 3 1 -> 1  n   x	  y
  #     (1) 3 9 9 3 -> n n*n n*x n*y
  #     (2) 3 9 9 3 -> x n*x x*x x*y
  #     (3) 1 3 3 1 -> y n*y x*y y*y

  # pyramid layer is cartesian product of two pascal triangle rows
  # x,y,row = (row! / row!(row!-x!)) * (row! / row!(row!-y!))

  # @param [Integer] row
  # @param [Integer] x (0..row-1)
  # @param [Integer] y (0..row-1)
  # @return [Integer]
  def self.get_pyramid_x_y_row_value(row, x, y)
    x = get_value_by_row_and_column(row, x)
    y = get_value_by_row_and_column(row, y)
    x * y
  end

  private

  # n! -> 1*2*3*...*n
  # @param [Integer] n
  # @return [Integer]
  def self.fact(n)
    (1..n).inject(:*) || 1
  end

end
