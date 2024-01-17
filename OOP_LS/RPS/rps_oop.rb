require 'yaml'
MESSAGES = YAML.load_file('rps_bonus.yml')

MOVES = ['rock', 'paper', 'scissor', 'spock', 'lizard']
COMPUTER_NAMES = ['MARIO', 'LUIGI', 'PEACH', 'BOWSER']
COMPUTER_MOVES = { 'PEACH' => ['rock'],
                   'LUIGI' => [MOVES, 'scissor', 'scissor'].flatten,
                   'BOWSER' => [MOVES, 'rock', 'paper'].flatten }

WINNING_COMB = { 'rock' => ['scissor', 'lizard'], 'paper' => ['rock', 'spock'],
                 'scissor' => ['paper', 'lizard'],
                 'spock' => ['rock', 'scissor'],
                 'lizard' => ['spock', 'paper'] }

module DisplayMessages
  def prompt(message)
    puts("=> #{message}")
  end

  def welcome
    prompt MESSAGES['welcome']
  end

  def display_move
    str = '-' * 50
    str += "\n\n=>#{name} chose #{move.move_type}\n\n"
    str += '-' * 50
    puts str
  end

  def display_score(p1, p2)
    str = '*' * 50
    str += "\n\n=>#{p1.name} score: #{p1.score} and #{p2.name}
            score: #{p2.score}\n\n"
    str += '*' * 50
    puts str
  end

  def display_winner
    str = '*' * 50
    str += "\n\n=>#{name} wins\n\n"
    str += '*' * 50
    puts str
  end

  def display_history
    move_length = move_record.length
    str = '*' * 50
    if move_length == 1
      str += "\n\nOnly move made by #{name} is #{move_record[0]}\n\n"
    else
      str += "\n\nMoves made by #{name} are "
      str += move_record[0, move_length - 1] \
             .join(',').concat(' and ', move_record[-1])
    end
    puts str
  end
end

class Player
  attr_accessor :name, :type, :score, :move_record

  include DisplayMessages
  def initialize
    @score = 0
    @move_record = []
    set_name
  end

  def set_name
    welcome
    human_name if type == :human
    @name = COMPUTER_NAMES.sample if type == :computer
  end

  def human_name
    name = ''
    loop do
      name = gets.chomp
      break if !name.empty?
      prompt MESSAGES['valid_name']
    end
    @name = name
  end

  def increment_score
    self.score += 1
  end
end

class Human < Player
  attr_accessor :name, :type, :move, :score

  def initialize
    @type = :human
    super
  end

  def choose
    move_temp = ''
    loop do
      prompt "Choose your move: "
      puts MOVES[0, MOVES.length - 1].join(',').concat(' or ', MOVES[-1])
      move_temp = gets.chomp
      break if MOVES.include?(move_temp)
    end
    @move = Move.new(move_temp)
    @move_record.push(move.move_type)
    display_move
  end
end

class Computer < Player
  attr_accessor :name, :type, :move, :score

  def initialize
    @type = :computer
    super
  end

  def choose
    if COMPUTER_MOVES.keys.include?(name)
      puts "name is in keyss"
      @move = Move.new(COMPUTER_MOVES[name].sample)
    else
      puts 'Name is not in keys'
      @move = Move.new(MOVES.sample)
    end
    @move_record.push(move.move_type)
    display_move
  end
end

class Move
  attr_accessor :move_type

  include DisplayMessages

  def initialize(mv)
    @move_type = mv
  end

  def >(other_move)
    WINNING_COMB[move_type].include?(other_move.move_type)
  end

  def <(other_move)
    WINNING_COMB[other_move.move_type].include?(move_type)
  end
end

class RpsEngine
  attr_accessor :p1, :p2

  include DisplayMessages

  def initialize(p1, p2)
    @p1 = p1
    @p2 = p2
  end

  def choose
    p1.choose
    p2.choose
  end

  def play_again?
    again = ''
    loop do
      puts "Do you want to play again (y/n)?"
      again = gets.chomp
      break if ['y', 'n'].include?(again.downcase)
      puts "Please enter 'y' or 'n'"
    end
    again.downcase == 'y'
  end

  def game_winner
    if p1.move > p2.move
      p1.display_winner
      p1.increment_score
    elsif p1.move < p2.move
      p2.display_winner
      p2.increment_score
    else
      puts "Its a tie"
    end
  end

  def rules_review
    prompt "Hello #{p1.name}"
    prompt "You will play against #{p2.name}"
    prompt "Do you want to review the rules? (Press 'y'
            to review rules or any other key to proceed)"
    rules_review = gets.chomp
    prompt MESSAGES['rules'] if rules_review.downcase.start_with?('y')
  end

  def run_game
    rules_review
    loop do
      choose
      game_winner
      display_score(p1, p2)
      break if !play_again?
    end
    display_score(p1, p2)
    p1.display_history
    p2.display_history
  end
end

fiz = Human.new
pc = Computer.new
game = RpsEngine.new(fiz, pc)
game.run_game
