=begin
Simple Calculator in Ruby
=end

def prompt(message)
  puts ("=> #{message}")
end

def valid_number?(num)
  num.to_i.to_s == num
end

prompt "Please enter your name"
name = ''
loop do
  name = gets.chomp
  break if !name.empty?()

  prompt "Make sure to use a valid name"
end
prompt "Hello #{name}"
loop do
  
  first_num = nil
  second_num = nil
  loop do
    
    prompt "Please enter first number"

    first_num = gets.chomp()
    break if valid_number?(first_num) # Check if its a valid number
    prompt "Please enter a valid number"
  end 

  loop do

    prompt "Please enter second number"

    second_num = gets.chomp()
    break if valid_number?(second_num) # Check if its a valid number
    prompt "Please enter a valid number"

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
              first_num.to_i + second_num.to_i
            when '2'
              first_num.to_i - second_num.to_i
            when '3'
              first_num.to_i * second_num.to_i
            when '4'
              first_num.to_i / second_num.to_i
          end

  prompt("the results is #{result}")

  prompt "Do you want to perform another calculation? (Y to calculate again)"
  answer = gets.chomp
  break unless answer.downcase.start_with?('y')

end