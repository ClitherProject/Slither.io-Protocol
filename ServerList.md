# Server List

Slither.io stores its global server list using strange scrambled format.  
This data can be found here: http://slither.io/i49526.txt

## Parsing
After some time reverse-engineering the javascript code I found the algorithm.

Lets take this string as an example:
`abcdefg`

### 1. Ignore the first character
For some reason the first character is never used. 
This could be a version indicator (at the time of writing this the character is an `a`).

result: `bcdefg`

### 2. Convert the characters to numbers
These can be calculated by subtracting 97 from each characters ascii value.

`a = 0, b = 1, c = 2, .. z = 25`

result: `[1, 2, 3, 4, 5, 6]`

### 3. Subtract 7*index from each value
`v[i] = v[i] - 7*i`

example: `[1 - 7*0, 2 - 7*1, 3 - 7*2, 4 - 7*3, 5 - 7*4]`

result: `[1, -5, -11, -17, -23, -29]`

### 4. Get the modulo (positive remainder) by 26
`v[i] = (v[i] % 26 + 26) % 26`

result: `[1, 21, 15, 9, 3, 23]`

### 5. Merge two pairs of numbers into one byte
`v[i] = v[i*2] * 16 + v[i*2 + 1]`

example: `[16*1 + 21, 16*15 + 9, 16*3 + 23]`

result: `[37, 249, 71]`

### 6. Read Server information
Our example did not have enough bytes to extract any meaningful data.
Because of this, we are going to use the string: `alhoegrwgelsarzubipydkt`.
This string should contain exactly one server.

Lets converted the string to smaller numbers (step 1 to 4):  
`[11,0,0,9,4,8,6,9,0,0,0,1,11,12,0,0,0,0,2,0,0,2]`

These get converted to bytes (step 5):  
`[176,9,72,105,0,1,188,0,0,32,2]`

The first 4 bytes are IPv4 numbers.  
Our example ip address is: `176.9.72.105`

The next 3 bytes get combined into a 24bit port number:  
In our example the port is: `0*256^2 + 1*256 + 188 = 444`

The next 3 bytes get combined into a 24 bit `ac` value (I don't know what this value is used for):  
In our example the ac value is: `0*256^2 + 0*256 + 32 = 32`

The next number is the `clu` value (this could stands for cluster, I don't know what it is used for):  
In our example the `clu` value is: `2`

Repeat this until all values are consumed.

Each server will need need 4+3+3+1=11 bytes, which are 11*2 = 22 characters.
