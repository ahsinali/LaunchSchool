require 'yaml'
MESSAGES = YAML.load_file('rps_bonus.yml')

VALID_CHOICES = %w(r p sc sp l)
VALID_CHOICES_DETAILS = { 'r' => 'rock', 'p' => 'paper', 'sc' => 'scissors',
                          'sp' => 'spock', 'l' => 'lizard' }
WINNING_COMB = { 'r' => ['sc', 'l'], 'p' => ['r', 'sp'], 'sc' => ['p', 'l'],
                 'sp' => ['r', 'sc'], 'l' => ['sp', 'p'] }

def win?(player1, player2)
  WINNING_COMB[player1].include?(player2)
end

def display_result(player, computer)
  if win?(player, computer)
    prompt "You won!"
  elsif win?(computer, player)
    prompt "Computer won"
  else
    prompt "Its a tie"
  end
end

def prompt(message)
  puts("=> #{message}")
end

prompt MESSAGES['welcome']

name = ''
loop do
  name = gets.chomp
  break if !name.empty?()

  prompt MESSAGES['valid_name']
end
prompt "Hello #{name}"

prompt "Do you want to review the rules"

rules_review = gets.chomp

if rules_review.downcase.start_with?('y')
  prompt MESSAGES['rules']
end

loop do
  prompt "Choose One:"
  VALID_CHOICES_DETAILS.each do |k, v|
    prompt "#{k} for #{v}"
  end

  choice = ''
  loop do
    choice = gets.chomp
    break if VALID_CHOICES.include?(choice)

    prompt "Thats not a valid choice"
  end

  computer_choice = VALID_CHOICES.sample

  prompt "You chose #{VALID_CHOICES_DETAILS[choice]} and computer chose #{VALID_CHOICES_DETAILS[computer_choice]}"

  display_result(choice, computer_choice)

  prompt "Do you want to play again"

  answer = gets.chomp

  break unless answer.downcase.start_with?('y')
end

prompt "Thank you #{name} for playing"
