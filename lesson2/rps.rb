class Move
  VALUES = ['rock', 'paper', 'scissors', 'lizard', 'Spock']
  attr_reader :value

  def initialize(value)
    @value = value
  end

  def scissors?
    @value == 'scissors'
  end

  def rock?
    @value == 'rock'
  end

  def paper?
    @value == 'paper'
  end

  def lizard?
    @value == 'lizard'
  end

  def spock?
    @value == 'Spock'
  end

  def rock_wins?(other_move)
    rock? && (other_move.lizard? || other_move.scissors?)
  end

  def paper_wins?(other_move)
    paper? && (other_move.rock? || other_move.spock?)
  end

  def scissors_wins?(other_move)
    scissors? && (other_move.paper? || other_move.lizard?)
  end

  def lizard_wins?(other_move)
    lizard? && (other_move.paper? || other_move.spock?)
  end

  def spock_wins?(other_move)
    spock? && (other_move.rock? || other_move.scissors?)
  end

  def >(other_move)
    rock_wins?(other_move) || paper_wins?(other_move) || scissors_wins?(other_move) || lizard_wins?(other_move) || spock_wins?(other_move)
  end
end

class Player
  attr_accessor :move, :name, :score
  attr_reader :player_type

  def initialize
    set_name
    @score = 0
  end

  def won_game?
    score == 10
  end
end

class Human < Player
  def set_name
    n = ''
    loop do
      puts "what's your name?"
      n = gets.chomp
      break unless n.empty?
      puts "sorry, must enter name to continue"
    end
    self.name = n
  end

  def choose
    choice = nil
    loop do
      puts "choose rock, paper, scissors, lizard or Spock"
      choice = gets.chomp
      break if Move::VALUES.include?(choice)
      puts "sorry, invalid response, try again"
    end
    self.move = Move.new(choice)
  end
end

class Computer < Player
  def set_name
    self.name = ['Alyssa', 'Computer', 'Cher', 'Ella',
                 'Valarie', 'Jabber', 'Chase'].sample
  end

  def choose
    self.move = Move.new(Move::VALUES.sample)
  end
end

class RPSGame
  attr_accessor :human, :computer

  def initialize
    @human = Human.new
    @computer = Computer.new
  end

  def display_welcome_message
    puts "welcome"
  end

  def display_goodbye_message
    puts "goodbye"
  end

  def display_moves
    puts "#{human.name} chose #{human.move.value}."
    puts "#{computer.name} chose #{computer.move.value}"
  end

  def display_winner
    if human.move > computer.move
      puts "#{human.name} won!"
    elsif computer.move > human.move
      puts "#{computer.name} won!"
    else
      puts "It's a tie!"
    end
  end

  def record_match_win
    if human.move > computer.move
      human.score += 1
    elsif computer.move > human.move
      computer.score += 1
    end
  end

  def display_scores
    puts "#{human.name} has a score of #{human.score}, #{computer.name} has a score of #{computer.score}."
  end

  def game_winner
    human.name if human.won_game?
    computer.name if computer.won_game?
  end

  def play_again?
    answer = nil
    loop do
      puts "do you want to play again?"
      answer = gets.chomp
      break if ['y', 'n'].include? answer.downcase
      puts "sorry, must be y or n"
    end

    return true if answer.downcase == 'y'
    false
  end

  def someone_won?
    human.won_game? || computer.won_game?
  end

  def display_results
    display_moves
    display_winner
    display_scores
  end

  def play
    display_welcome_message
    loop do
      human.choose
      computer.choose
      record_match_win
      display_results
      if someone_won?
        puts "#{game_winner} wins the game!"
        break
      end
      break unless play_again?
    end
    display_goodbye_message
  end
end

RPSGame.new.play
