(1..20).each do |count|
  if count % 15 == 0
    puts "FizzBuzz"
  elsif count % 3 == 0
    puts "Fizz"
  elsif count % 5 == 0
    puts "Buzz"
  else
    puts count
  end
end
