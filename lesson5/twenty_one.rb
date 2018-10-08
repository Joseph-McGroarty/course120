class Participant
  attr_accessor :stays, :busts, :hand, :hits
  def initialize(*)
    @hand = []
    @stays = nil
    @hits = nil
  end

  def stays?
    !!stays
  end

  def busts?
    total > 21
  end

  def hits?
    !!hits
  end

  def total
    the_total = 0
    hand.each do |card|
      the_total += card.value
    end

    num_of_aces = hand.count { |card| card.face == :ace }
    num_of_aces.times do
      the_total -= 10 if the_total > 21
    end
    the_total
  end

  def joiner(an_array, connector = ', ', joining_word = 'and')
    case an_array.size
    when 0 then ''
    when 1 then an_array.first
    when 2 then an_array.join(" #{joining_word} ")
    else
      an_array[0..(an_array.size - 2)].join(connector) + ", #{joining_word} " + an_array.last.to_s
    end
  end

  def show_hand
    puts "#{name} has #{joiner(hand)}, for a total of #{total}."
  end
end

class Human < Participant
  attr_reader :name
  def initialize
    super
    @name = human_enters_name
  end

  def hits_or_stays
    human_choice = nil
    loop do
      puts "do you want to hit or stay?"
      human_choice = gets.chomp.downcase
      break if human_choice == 'hit' || human_choice == 'stay'
      puts "invalid choice, try again"
    end
    @hits = true if human_choice == 'hit'
    if human_choice == 'stay'
      @hits = false
      @stays = true
    end
  end

  def human_enters_name
    human_name = nil
    loop do
      puts "what's your name?"
      human_name = gets.chomp
      break unless human_name.strip.empty?
      puts "you must enter a name, try again."
    end
    human_name
  end
end

class Dealer < Participant
  attr_accessor :name

  def initialize(player_name)
    super
    @name = chooses_a_name(player_name)
  end

  def chooses_a_name(player_name)
    dealer_names = ['Santana', 'Kurt', 'Brittany', 'Rachel', 'Mercedes']
    dealer_name = dealer_names.sample
    loop do
      break unless dealer_name == player_name
      dealer_name = dealer_names.sample
    end
    dealer_name
  end

  def hits_or_stays
    if total < 17
      @hits = true
    else
      @hits = false
      @stays = true
    end
  end

  def showing_card
    puts "#{name} is showing #{hand[0]}"
  end
end

class Card
  VALUES = { ace: 11, two: 2, three: 3, four: 4, five: 5,
             six: 6, seven: 7, eight: 8, nine: 9, ten: 10,
             jack: 10, queen: 10, king: 10 }

  attr_reader :face, :suit

  def initialize(face, suit)
    @face = face
    @suit = suit
  end

  def to_s
    "#{face} of #{suit}"
  end

  def value
    VALUES[face]
  end
end

class Deck
  FACES = [:ace, :two, :three, :four, :five,
           :six, :seven, :eight, :nine, :ten,
           :jack, :queen, :king]
  SUITS = ['diamonds', 'clubs', 'hearts', 'spades']
  attr_accessor :deck

  def initialize
    @deck = []
    FACES.each do |face|
      SUITS.each do |suit|
        deck << Card.new(face, suit)
      end
    end
    deck.shuffle!
  end

  def deal_to(hand)
    hand << deck.pop
  end
end

class TOGame
  attr_accessor :human, :dealer, :deck
  def initialize
    clear_screen

    @human = Human.new
    @dealer = Dealer.new(human.name)
    @deck = Deck.new

    2.times do
      deck.deal_to(human.hand)
      deck.deal_to(dealer.hand)
    end
  end

  def start
    display_welcome_message
    loop do
      human_turn
      dealer_turn if human.stays?
      display_result
      play_again? ? reset : break
    end
    display_goodbye_message
  end

  def display_welcome_message
    puts "welcome to twenty one, #{human.name}"
    puts 'shuffling deck...'
    puts 'dealing cards...'
  end

  def clear_screen
    system 'clear'
  end

  def display_table
    human.show_hand
    dealer.showing_card
  end

  def human_turn
    loop do
      display_table
      human.hits_or_stays
      deck.deal_to(human.hand) if human.hits?
      break if human.stays? || human.busts?
    end
  end

  def dealer_turn
    loop do
      dealer.hits_or_stays
      if dealer.hits?
        deck.deal_to(dealer.hand)
        puts "#{dealer.name} hits."
      end
      break if dealer.stays? || dealer.busts?
    end
    puts "#{dealer.name} stays." if dealer.stays?
  end

  def display_result
    if human.busts?
      human.show_hand
      puts "#{human.name} busted, #{dealer.name} wins!"
    elsif dealer.busts?
      dealer.show_hand
      puts "#{dealer.name} busted, #{human.name} wins!"
    else
      compare_hands
    end
  end

  def compare_hands
    human.show_hand
    dealer.show_hand
    announce_winner
  end

  def announce_winner
    if human.total > dealer.total
      puts "#{human.name} wins!"
    elsif dealer.total > human.total
      puts "#{dealer.name} wins!"
    else
      puts "it's a tie!"
    end
  end

  def display_goodbye_message
    puts "thanks for playing, #{human.name}!"
  end

  def play_again?
    choice = nil
    loop do
      puts "do you want to play again? (y or n)"
      choice = gets.chomp.downcase
      break if ['y', 'n'].include?(choice)
      puts "invalid choice, must enter y or n."
    end
    choice == 'y'
  end

  def reset
    deck = Deck.new
    human.hand = []
    dealer.hand = []
    2.times do
      deck.deal_to(human.hand)
      deck.deal_to(dealer.hand)
    end
    clear_screen
  end
end

game = TOGame.new
game.start
