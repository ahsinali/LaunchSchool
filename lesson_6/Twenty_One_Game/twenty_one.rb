require 'pry'
SUITS = ['H', 'D', 'C', 'S']
VALUES = ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'Jack',
          'Queen', 'King', 'Ace']

initial_cards = SUITS.product(VALUES).shuffle!
cards = { "deck" => initial_cards, "player" => [], "dealer" => [] }

def prompt(str)
  puts ">>>>>  " + str
end

def deal_cards(cards)
  cards["player"] = cards["deck"].shift(2)
  cards["dealer"] = cards["deck"].shift(2)
end

def create_display_string(cards, hand, player_turn)
  cards_string = ''
  cards_on_hand = card_numbers(cards, hand)
  if hand == 'dealer' && player_turn
    cards_string = cards_on_hand[0, cards_on_hand.size - 1].join(',') + \
                   ' and unknown'
  else
    cards_string = cards_on_hand[0, cards_on_hand.size - 1].join(',') + \
                   ' and ' + cards_on_hand[cards_on_hand.size - 1]
  end
  cards_string
end

def display_cards(cards, player_turn)
  prompt "Player has " + create_display_string(cards, 'player', player_turn)
  prompt "Dealer has " + create_display_string(cards, 'dealer', player_turn)
end

def card_numbers(cards, hand)
  cards[hand].map do |num|
    num[1]
  end
end

def deal_additional_card(cards, side)
  cards[side].push(cards["deck"].shift(1).flatten)
end

def includes_ace?(hand)
  hand.include?("Ace")
end

def card_value(hand)
  case hand
  when 'Jack'
    11
  when 'Queen'
    12
  when 'King'
    13
  else
    hand.to_i
  end
end

def non_ace_cards(hand)
  hand.select do |crd|
    crd != "Ace"
  end
end

def points_ex_ace(hand)
  crd = non_ace_cards(hand)
  points = crd.reduce(0) do |sum, x|
    sum + card_value(x)
  end
  points
end

def num_aces(hand)
  hand.count { |ele| ele == "Ace" }
end

def determine_ace_value(hand)
  points_before = points_ex_ace(hand)
  num_of_aces = num_aces(hand)
  max_ace_value = 0
  min_ace_value = 0
  if num_of_aces > 0
    max_ace_value = 11 + (num_of_aces - 1) * 1
    min_ace_value = num_of_aces * 1
  end
  (21 - points_before) > max_ace_value ? max_ace_value : min_ace_value
end

def detect_winner(player_points, dealer_points)
  if dealer_points > 21
    'player'
  elsif dealer_points >= 17 && dealer_points > player_points
    'dealer'
  elsif player_points > 21
    'dealer'
  end
end

def someone_won?(player_points, dealer_points)
  !!detect_winner(player_points, dealer_points)
end

def calculate_points(hand)
  total_points = if hand.include?("Ace")
                   (points_ex_ace(hand) + determine_ace_value(hand))
                 else
                   points_ex_ace(hand)
                 end
  total_points
end

deal_cards(cards)

bust = false
player_points = 0
dealer_points = 0
player_turn = true

loop do
  hand = card_numbers(cards, "player")
  player_points = calculate_points(hand)
  bust = player_points > 21
  break if bust
  display_cards(cards, player_turn)
  prompt "Player Points are: #{player_points}"
  puts "hit or stay?"
  answer = gets.chomp
  break if answer == 'stay'
  deal_additional_card(cards, 'player')
end
player_turn = false
if player_points > 21
  display_cards(cards, player_turn)
  prompt "Player has #{player_points} points......Player loses"
elsif loop do
        display_cards(cards, player_turn)
        hand = card_numbers(cards, "dealer")
        dealer_points = calculate_points(hand)
        prompt "Player Points are: #{player_points}"
        prompt "And Dealer Points are: #{dealer_points}"
        prompt "Enter any Key to continue"
        break if someone_won?(player_points, dealer_points)
        prompt "Enter any key to continue"
        answer = gets.chomp
        deal_additional_card(cards, 'dealer')
      end
end

prompt "#{detect_winner(player_points, dealer_points)} Won"
