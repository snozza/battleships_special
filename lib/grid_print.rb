require 'terminal-table/import'

module GridPrint
  
  def print_boards(board)
    letters = (1..10).to_a.unshift(" ")
    #board duped in order not to modify original grid
    temp_board = Marshal.load(Marshal.dump(board.grid))
      ("A".."J").each do |n|
        temp_board[n.ord - 65].unshift(n)
      end
    puts table(letters, *temp_board)
  end
end



  