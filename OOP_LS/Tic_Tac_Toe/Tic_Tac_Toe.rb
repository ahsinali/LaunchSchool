require 'pry'
require 'yaml'
MESSAGES = YAML.load_file('Tic_Tac_Toe.yml')

class Board
  WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] +
                  [[1, 4, 7], [2, 5, 8], [3, 6, 9]] +
                  [[1, 5, 9], [3, 5, 7]]

  def initialize
    @square = {}
    reset
  end

  def reset
    (1..9).each { |key| @square[key] = Square.new }
  end

  def identify_unmarked_squares
    @square.keys.select { |k| !@square[k].marked? }
  end

  def someone_won?
    !!winning_marker
  end

  def winning_marker
    WINNING_LINES.each do |line|
      squares = @square.values_at(*line)
      if three_identical_markers(squares)
        return squares.first.marker
      end
    end
    nil
  end

  def find_at_risk_square(marker, init_maker = Square::INITIAL_MARKER)
    risk_square = nil
    WINNING_LINES.each do |line|
      squares = @square.values_at(*line)
      if at_risk_square?(squares, marker)
        square_idx = squares.map(&:marker).index { |idx| idx == init_maker }
        return line[square_idx]
      end
    end
    risk_square
  end

  def at_risk_square?(squares, marker)
    markers = squares.select(&:marked?).map(&:marker)
    return true if markers.count(marker) == 2 && markers.size == 2
    nil
  end

  def three_identical_markers(squares)
    markers = squares.select(&:marked?).map(&:marker)
    return false if markers.size != 3
    markers.uniq.count == 1
  end

  # rubocop: disable Metrics/AbcSize
  # rubocop: disable Metrics/MethodLength
  def display_board
    system 'clear'
    puts ""
    puts "        |          |"
    puts " #{@square[1]}      |     #{@square[2]}    |  #{@square[3]}"
    puts "        |          |"
    puts "--------+----------+---------"
    puts "        |          |"
    puts " #{@square[4]}      |     #{@square[5]}    |  #{@square[6]}"
    puts "        |          |"
    puts "--------+----------+---------"
    puts "        |          |"
    puts " #{@square[7]}      |     #{@square[8]}    |  #{@square[9]}"
    puts "        |          |"
    puts ""
  end
  # rubocop: enable Metrics/MethodLength
  # rubocop: enable Metrics/AbcSize

  def []=(num, marker)
    @square[num].marker = marker
  end
end

class Player
  attr_reader :marker, :name
  attr_accessor :games_won

  def initialize(marker, name)
    @marker = marker
    @games_won = 0
    @name = name
  end
end

class Square
  attr_accessor :marker

  INITIAL_MARKER = ' '
  def initialize(marker = INITIAL_MARKER)
    @marker = marker
  end

  def to_s
    @marker
  end

  def marked?
    marker != INITIAL_MARKER
  end
end

class TTTGame
  attr_accessor :board, :human, :computer

  COMPUTER_MARKER = 'O'
  COMPUTER_NAMES = ['MARIO', 'LUIGI', 'PEACH', 'BOWSER']
  REQUIRED_WINS = 5

  def initialize
    display_welcome
    human_name = input_human_name
    @board = Board.new
    @human_marker = choose_human_marker
    @human = Player.new(@human_marker, human_name)
    @computer = Player.new(COMPUTER_MARKER, COMPUTER_NAMES.sample)
    @current_marker = first_to_move
  end

  def display_welcome
    puts MESSAGES['welcome']
  end

  def choose_human_marker
    system 'clear'
    puts MESSAGES['marker_value']
    chosen_marker = ''
    loop do
      chosen_marker = gets.chomp.upcase
      break if chosen_marker != COMPUTER_MARKER && chosen_marker.length == 1
      puts MESSAGES['invalid_marker_pc'] if chosen_marker == COMPUTER_MARKER
      puts "please input a single character" if chosen_marker.length > 1
    end
    chosen_marker
  end

  def first_to_move
    puts "Choose who plays first (1 for Player and 2 for Computer)"
    first_to_go = ''
    loop do
      first_to_go = gets.chomp
      break if ["1", "2"].include?(first_to_go)
      puts "Choose a valid option: 1 for Player and 2 for Computer"
    end
    first_to_go == "1" ? @human_marker : COMPUTER_MARKER
  end

  def input_human_name
    puts MESSAGES['enter_name']
    name = ''
    loop do
      name = gets.chomp.strip
      break if !name.empty?
      puts MESSAGES['valid_name']
    end
    name
  end

  def joinor(arr, word = 'or')
    case arr.size
    when 0 then ''
    when 1 then arr.first
    when 2 then arr.join(" #{word}")
    else
      arr[0, arr.size - 1].join(',').concat(" #{word} ", arr[-1].to_s)
    end
  end

  def display_move_options(unmarked_squares)
    puts "You can choose #{joinor(unmarked_squares)}"
  end

  def get_player_move(unmarked_squares)
    move = ''
    loop do
      move = gets.chomp.to_i
      break if unmarked_squares.include?(move.to_i)
      puts "please choose a valid move"
      display_move_options(unmarked_squares)
    end
    board[move] = human.marker
  end

  def player_turn
    unmarked_squares = board.identify_unmarked_squares
    display_move_options(unmarked_squares)
    get_player_move(unmarked_squares)
  end

  def find_at_risk_square
    board.find_at_risk_square(@human_marker)
  end

  def computer_turn(marker)
    unmarked_squares = board.identify_unmarked_squares
    human_risk = board.find_at_risk_square(@human_marker)
    computer_risk = board.find_at_risk_square(COMPUTER_MARKER)
    if !computer_risk.nil?
      board[computer_risk] = marker
    elsif !human_risk.nil?
      board[human_risk] = marker
    else
      board[unmarked_squares.sample] = marker
    end
  end

  def board_full?
    unmarked_squares = board.identify_unmarked_squares
    unmarked_squares.empty?
  end

  def display_round_winner
    case board.winning_marker
    when @human_marker
      puts "#{@human.name} won the round"
    when COMPUTER_MARKER
      puts "#{@computer.name} won the round"
    else
      puts "Its a draw"
    end
  end

  def increment_score
    case board.winning_marker
    when @human_marker
      human.games_won += 1
    when COMPUTER_MARKER
      computer.games_won += 1
    end
  end

  def display_current_score
    puts "#{@computer.name} has won: #{computer.games_won} round(s)" \
          "and you have won: #{human.games_won} round(s)"
  end

  def play_again?
    user_input = ''
    loop do
      puts "#{@human.name}, Do you want to play again? (y or n)"
      user_input = gets.chomp.downcase
      break if ['y', 'n'].include?(user_input)
      puts "Please enter: y or n"
    end
    user_input == 'y'
  end

  def clear_board
    system 'clear'
  end

  def reset
    puts "Press any key to continue"
    key_continue = gets.chomp
    clear_board
    board.reset
    @current_marker = first_to_move
  end

  def next_player_turn
    if @current_marker == @human_marker
      player_turn
      @current_marker = COMPUTER_MARKER
    elsif @current_marker == COMPUTER_MARKER
      computer_turn(COMPUTER_MARKER)
      @current_marker = @human_marker
    end
  end

  def display_play_next_round
    puts "Lets play another round"
  end

  def display_play_again_message
    puts "Lets play another game"
  end

  def player_move
    loop do
      next_player_turn
      break if board.someone_won? || board_full?
      board.display_board
    end
    increment_score
    board.display_board
  end

  def someone_won_five?
    human.games_won == REQUIRED_WINS || computer.games_won == REQUIRED_WINS
  end

  def display_winner
    if human.games_won == REQUIRED_WINS
      puts "You won the game"
    elsif computer.games_won == REQUIRED_WINS
      puts "Computer won the game"
    end
  end

  def each_game
    loop do
      board.display_board
      player_move
      display_round_winner
      break if someone_won_five?
      display_current_score
      reset
      display_play_next_round
    end
  end

  def main_game
    loop do
      each_game
      display_winner
      break if !play_again?
      reset
      display_play_again_message
    end
  end

  def play
    display_welcome
    main_game
  end
end

gm = TTTGame.new
gm.play
