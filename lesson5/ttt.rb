class Board
  attr_reader :squares
  WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9],
                   [1, 4, 7], [2, 5, 8], [3, 6, 9],
                   [1, 5, 9], [3, 5, 7]]
  def initialize
    @squares = { 1 => Square.new, 2 => Square.new,
                 3 => Square.new, 4 => Square.new,
                 5 => Square.new, 6 => Square.new,
                 7 => Square.new, 8 => Square.new,
                 9 => Square.new }
  end

  def []=(key, marker)
    @squares[key].marker = marker
  end

  def unmarked_keys
    @squares.keys.select { |key| @squares[key].unmarked? }
  end

  def full?
    unmarked_keys.empty?
  end

  def someone_won?
    !!winning_marker
  end

  def count_num_of_a_marker(squares)
    squares.collect(&:marker).count(squares[0].marker)
  end

  def count_a_specific_marker(squares, marker)
    squares.collect(&:marker).count(marker)
  end

  def winning_marker
    WINNING_LINES.each do |line|
      return @squares.values_at(line[0]).first.marker if
        count_num_of_a_marker(@squares.values_at(*line)) == 3 &&
        @squares.values_at(line[0]).first.marker != ' '
    end
    nil
  end

  # rubocop:disable Metrics/AbcSize
  def draw
    puts ""
    puts "     |     |     "
    puts "  #{@squares[1]}  |  #{@squares[2]}  |  #{@squares[3]}  "
    puts "     |     |     "
    puts "-----+-----+-----"
    puts "     |     |     "
    puts "  #{@squares[4]}  |  #{@squares[5]}  |  #{@squares[6]}  "
    puts "     |     |     "
    puts "-----+-----+-----"
    puts "     |     |     "
    puts "  #{@squares[7]}  |  #{@squares[8]}  |  #{@squares[9]}  "
    puts "     |     |     "
    puts ""
  end
  # rubocop:enable Metrics/AbcSize
end

class Square
  INITIAL_MARKER = ' '

  attr_accessor :marker

  def initialize(marker = INITIAL_MARKER)
    @marker = marker
  end

  def to_s
    @marker
  end

  def unmarked?
    marker == INITIAL_MARKER
  end
end

class Player
  attr_reader :marker, :name
  def initialize(marker, name)
    @marker = marker
    @name = name
  end
end

class TTTGame
  attr_reader :board, :human, :computer
  def initialize
    @board = Board.new
    @human = Player.new(humans_chosen_marker, human_name)
    @computer = Player.new(unchosen_marker, computer_name)
    @first_to_move = human.marker
    @current_marker = @first_to_move
    @human_wins = 0
    @computer_wins = 0
  end

  def play
    clear_the_screen
    display_welcome_message

    loop do
      display_board
      loop do
        current_player_moves
        clear_screen_and_display_board if human_turn?
        break if board.full? || board.someone_won?
      end
      increment_scores
      display_result
      if @human_wins == 5 || @computer_wins == 5
        display_game_winner
        break
      end
      break unless play_again?
      reset
      display_play_again_message
    end
    display_goodbye_message
  end

  private

  def human_name
    puts "what's you're name?"
    name = ''
    loop do
      name = gets.chomp
      break if name.empty? == false
      puts 'you must enter a name'
    end
    name
  end

  def computer_name
    %w(Data Riker Piccard Roe Warf Crusher Troi).sample
  end

  def humans_chosen_marker
    puts "would you like to be X's or O's?"
    puts "enter 'X' or 'O'."
    human_marker_choice = nil
    loop do
      human_marker_choice = gets.chomp.upcase
      break if human_marker_choice == 'X' || human_marker_choice == 'O'
      puts "invalid choice: choose 'X' or 'O'."
    end
    human_marker_choice
  end

  def unchosen_marker
    return 'O' if human.marker == 'X'
    return 'X' if human.marker == 'O'
  end

  def display_game_winner
    puts "#{human.name} wins game!" if @human_wins == 5
    puts "#{computer.name} wins game!" if @computer_wins == 5
  end

  def increment_scores
    @human_wins += 1 if board.winning_marker == human.marker
    @computer_wins += 1 if board.winning_marker == computer.marker
  end

  def joiner(an_array, connector = ', ', joining_word = 'or')
    case an_array.size
    when 0 then ''
    when 1 then an_array.first
    when 2 then an_array.join(" #{joining_word} ")
    else 
      an_array[0..(an_array.size - 2)].join(connector) + ", #{joining_word} " + an_array.last.to_s
    end
  end

  def display_welcome_message
    puts "welcome to tic tac toe, #{human.name}!"
    puts ''
  end

  def display_goodbye_message
    puts "Thanks for playing, #{human.name}."
  end

  def human_moves
    puts "Chose a square: #{joiner(board.unmarked_keys)}"
    square = nil
    loop do
      square = gets.chomp.to_i
      break if board.unmarked_keys.include?(square)
      puts "sorry, invalid choice, try again"
    end
    board[square] = human.marker
  end

  def computer_winning_square
    Board::WINNING_LINES.each do |line|
      if board.count_a_specific_marker(board.squares.values_at(*line), computer.marker) == 2 && board.count_a_specific_marker(board.squares.values_at(*line), Square::INITIAL_MARKER) == 1
        return board.squares.select{ |key, sq| (key == line[0] || key == line[1] || key == line[2]) && sq.marker == Square::INITIAL_MARKER }.keys[0]
      end
    end
    nil
  end

  def computer_defensive_square
    Board::WINNING_LINES.each do |line|
      if board.count_a_specific_marker(board.squares.values_at(*line), human.marker) == 2 && board.count_a_specific_marker(board.squares.values_at(*line), Square::INITIAL_MARKER) == 1
        return board.squares.select{ |key, sq| (key == line[0] || key == line[1] || key == line[2]) && sq.marker == Square::INITIAL_MARKER }.keys[0]
      end
    end
    nil
    # returns square key if computer can stop player from winning on next turn, else returns nil
  end

  def five_is_empty?
    board.unmarked_keys.to_a.include?(5)
  end

  def computer_moves
    computer_choice = nil
    if computer_winning_square
      computer_choice = computer_winning_square
    elsif computer_defensive_square
      computer_choice = computer_defensive_square
    elsif five_is_empty?
      computer_choice = 5
    else
      computer_choice = board.unmarked_keys.to_a.sample
    end
    board[computer_choice] = computer.marker
  end

  def display_board
    puts "#{human.name} has #{human.marker}, #{computer.name} has #{computer.marker}"
    board.draw
  end

  def clear_screen_and_display_board
    clear_the_screen
    display_board
  end

  def display_result
    display_board
    case board.winning_marker
    when human.marker
      puts "#{human.name} wins!"
    when computer.marker
      puts "#{computer.name} wins!"
    when nil
      puts 'board is full'
    end
    display_scores
  end

  def display_scores
    puts "#{human.name} score: #{@human_wins}, #{computer.name} score: #{@computer_wins}"
  end

  def play_again?
    answer = nil
    loop do
      puts 'would you like to play again? (y/n'
      answer = gets.chomp.downcase
      break if ['y', 'n'].include?(answer)
      puts 'must enter y or n'
    end
    answer == 'y'
  end

  def reset_board
    @board = Board.new
  end

  def clear_the_screen
    system 'clear'
  end

  def reset
    reset_board
    @current_marker = @first_to_move
    clear_the_screen
  end

  def display_play_again_message
    puts "let's play again"
  end

  def human_turn?
    @current_marker == human.marker
  end

  def current_player_moves
    if human_turn?
      human_moves
      @current_marker = computer.marker
    else
      computer_moves
      @current_marker = human.marker
    end
  end
end

game = TTTGame.new
game.play
