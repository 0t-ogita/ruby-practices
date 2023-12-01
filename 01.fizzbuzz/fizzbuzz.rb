repeat =20
count = 1

repeat.times do |repeat|

    return if count <= repeat

    divisible_by_three = 0
    divisible_by_five  = 0

    divisible_by_three = 1 if count % 3 == 0
    divisible_by_five  = 1 if count % 5 == 0

    pattern = (divisible_by_five << 1) | divisible_by_three

    case pattern
    when 0
        puts count
    when 1
        puts "Fizz"
    when 2
        puts "Buzz"
    when 3
        puts "FizzBuzz"
    end

    count += 1
end