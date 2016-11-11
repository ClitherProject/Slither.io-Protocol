#!/usr/bin/env ruby

require 'open-uri'
contents  = open('http://slither.io/i33628.txt') {|f| f.read}

def to24bit(val1, val2, val3)
	return (val1 * (256^2)) + (val2 * 256) + val3
end

# Step 1
dropped = contents.split('').drop(1)

# Step 2
converted = dropped.map {|n| n.ord - 97}

# Step 3
subtracted = converted.each_with_index.map {|n, i| n - (7 * i)} 

# Step 4
moduloed = subtracted.map {|n| (n % 26 + 26) % 26}

# Step 5
evens = moduloed.values_at(* moduloed.each_index.select {|i| i.even?})
evens = evens.map {|n| n * 16}
odds = moduloed.values_at(* moduloed.each_index.select {|i| i.odd?})
merged = [evens, odds].transpose.map {|x| x.reduce(:+)}

i = 0 
while i < merged.size do
	puts "ip:   #{merged[i]}.#{merged[i+1]}.#{merged[i+2]}.#{merged[i+3]}"
	i += 4
	puts "port: #{to24bit(merged[i], merged[i+1], merged[i+2])}"
	i += 3
	puts "ac:   #{to24bit(merged[i], merged[i+1], merged[i+2])}"
	i += 3
	puts "clu:  #{merged[i]}\n\n"
	i += 1
end