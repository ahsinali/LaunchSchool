=begin
Simple Calculator in Ruby
=end

require 'yaml'
MESSAGES = YAML.load_file('calculator_messages.yml')

def prompt(message)
  puts ("=> #{message}")
end

def valid_int?(num)
  num.to_i.to_s == num
end 

def valid_float?(num)
  num.to_f.to_s == num
end 

def valid_number?(num)
  #num.to_i.to_s == num
  valid_int?(num) || valid_float?(num)
end

prompt MESSAGES['welcome']

name = ''
loop do
  name = gets.chomp
  break if !name.empty?()

  prompt MESSAGES['valid_name']
end
prompt "Hello #{name}"
loop do
  
  first_num = nil
  second_num = nil
  loop do
    
    prompt MESSAGES['first_num']

    first_num = gets.chomp()
    break if valid_number?(first_num) # Check if its a valid number
    prompt MESSAGES['valid_number']
  end 

  loop do

    prompt MESSAGES['second_num']

    second_num = gets.chomp()
    break if valid_number?(second_num) # Check if its a valid number
    prompt MESSAGES['valid_number']

  end 

  operator_prompt = <<-MSG "What operation do you want to use:" 
      "1. Add
      2. Subtract
      3. Multiply
      4. Divide"

  MSG

  prompt(operator_prompt)
  operator = nil
  loop do
    operator = gets.chomp
    break if %w(1 2 3 4).include?(operator)
    prompt "Please choose 1,2,3 or 4"
  end

   result = case operator 
            when '1'
              first_num.to_f + second_num.to_f
            when '2'
              first_num.to_f - second_num.to_f
            when '3'
              first_num.to_f * second_num.to_f
            when '4'
              first_num.to_f / second_num.to_f
          end

  prompt("the results is #{result}")

  prompt "Do you want to perform another calculation? (Y to calculate again)"
  answer = gets.chomp
  break unless answer.downcase.start_with?('y')

end