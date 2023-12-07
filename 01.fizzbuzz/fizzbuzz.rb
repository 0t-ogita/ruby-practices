(1..20).each do |count|
  if count % 3 == 0
    puts "Fizz"
  elsif count % 5 == 0
    puts "Buzz"
  elsif count % 15 == 0
    puts "FizzBuzz"
  else
    puts count
  end
end
