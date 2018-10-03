module Identifyable
  def scissors?
    @value.class == Scissors
  end

  def rock?
    @value.class == Rock
  end

  def paper?
    @value.class == Paper
  end

  def lizard?
    @value.class == Lizard
  end

  def spock?
    @value.class == Spock
  end
end

class Rock
  include Identifyable
  def wins?(other_move)
    other_move.lizard? || other_move.scissors?
  end

  def to_s
    'rock'
  end
end

class Paper
  include Identifyable
  def wins?(other_move)
    other_move.rock? || other_move.spock?
  end

  def to_s
    'paper'
  end
end

class Scissors
  include Identifyable
  def wins?(other_move)
    other_move.paper? || other_move.lizard?
  end

  def to_s
    'scissors'
  end
end

class Lizard
  include Identifyable
  def wins?(other_move)
    other_move.paper? || other_move.spock?
  end

  def to_s
    'lizard'
  end
end

class Spock
  include Identifyable
  def wins?(other_move)
    other_move.rock? || other_move.scissors?
  end

  def to_s
    'Spock'
  end
end

class Move
  include Identifyable
  VALUES = { 'rock' => Rock.new,
             'paper' => Paper.new,
             'scissors' => Scissors.new,
             'lizard' => Lizard.new,
             'Spock' => Spock.new }
  attr_reader :value

  def initialize(value)
    @value = VALUES[value]
  end

  def >(other_move)
    @value.wins?(other_move)
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
      break if Move::VALUES.keys.include?(choice)
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
    self.move = Move.new(Move::VALUES.keys.sample)
  end
end

class History
  attr_accessor :history
  def initialize
    @history = []
  end

  def record(hum_move, comp_move, winner)
    @history << [hum_move, comp_move, winner]
  end

  def display(hname, cname)
    puts "History of moves and wins is:"
    @history.each_with_index do |round_rec, index|
      puts "Round #{index + 1}: #{hname} chose #{round_rec[0]}, #{cname} chose #{round_rec[1]}, #{round_rec[2]} won."
    end
  end
end

class RPSGame
  attr_accessor :human, :computer, :history

  def initialize
    @human = Human.new
    @computer = Computer.new
    @history = History.new
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

  def keep_score
    if human.move > computer.move
      human.score += 1
    elsif computer.move > human.move
      computer.score += 1
    end
  end

  def record_match_win
    keep_score
    history.record(human.move.value, computer.move.value, who_won_match)
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
    history.display(human.name, computer.name)
  end

  def who_won_match
    return human.name if human.move > computer.move
    return computer.name if computer.move > human.move
    'nobody'
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
