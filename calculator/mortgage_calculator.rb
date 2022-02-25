
def prompt(message)
  puts(">> #{message}")
end

def valid_float?(num)
  num.to_f.to_s == num && num.to_f >=0
end

def valid_int?(num)
  num.to_i.to_s == num && num.to_i >=0
end

loop do
  prompt "Enter your Name"
  name = gets.chomp
  prompt "Hello #{name}"

  prompt "Please Enter Loan Amount"

  
  loan_amt = nil
  loop do 
    loan_amt = gets.chomp
    break if valid_float?(loan_amt) || valid_int?(loan_amt)
    
    # if num is invalid
    prompt "Please enter a valid number"

  end

  prompt "Please enter an monthly interest rate in APR %"
  int_rate = nil
  loop do
    int_rate = gets.chomp
    break if valid_float?(int_rate) || valid_int?(int_rate)

    prompt "Please enter a valid interest rate number"
  end

  prompt "Please enter the tenor in years and months"

  years = nil
  loop do 
    prompt "number of years"
    years = gets.chomp
    break if valid_int?(years) 

    prompt "Please enter a valid integer for years"
  end
  months = nil
  loop do 
    prompt "Months"
    months = gets.chomp
    break if valid_int?(months) && months.to_i < 12

    prompt "Please enter a valid integer for months between 0 and 11"
  end
  int_rate = int_rate.to_f/1200
  loan_duration = (years.to_i )*12 + months.to_i

  payment = loan_amt.to_f * (int_rate.to_f / (1 - (1 + int_rate.to_f)**(-loan_duration.to_i)))

  prompt "The monthly payment is #{payment.round(3)}"

  prompt "Do you want to perform another calculation? (Y to calculate again)"
  answer = gets.chomp
  break unless answer.downcase.start_with?('y')
end
