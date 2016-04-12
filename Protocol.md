### Slither.io Protocol Version 6

##### From Server

Every Packet that comes from the Server starts with 3 byte. The first 3. byte is the Message Type (The game converts the byte to an unicode char so i will only speak of the chars not the byte values).

The Most Packets starts as following:

<table>
  <tr>
    <th>byte0</th>
     <th>byte1</th>
     <th>byte2</th>
     <th>byte3</th>
     <th>byte4</th>
   </tr>
   <tr>
    <td></td>
    <td></td>
     <td >msg type</td>
     <td colspan="2">snake id</td>
   </tr>
 </table>
 
 
 
|Msg Char|Use            |
|--------|---------------|
| a      | Initial Setup |
|e,E,3,4,5| -        |
|h       |snake "fam" variable|
|r       |maybe snake parts|
|g,n,G,N | -              |
|l       | -|
|v|dead/disconnect packet|
|w|-|
|m|global score packet|
|p|ping/pong packet|
|u|food on minimap i think|
|s|new Snake|
|F|something with new Food|
|b,f|something with new Food|
|c|i think food eaten|
|j|something with the preys (maybe the flying food things)|
|y|newPrey|


## Serverbound

(Bytes are 0 based)

### Packet a (InitialPacket)
Tells the Client some basic information. After the msg arrives the game calls "startShowGame();"

|bytes|Data type|Description
|-----|---------|---------
|3-5|int24|Game Radius (default 21600)
|6-7|int16|setMscps(value) (default 411) ? setMscps is used to fill the arrays fmlts and fpsls. But Idk for what they are
|8-9|int16|sector_size (default 480)
|10-11|int16|sector_count_along_edge (default 130)
|12|int8|spangdv (value / 10) (default 4.8)
|13-14|int16|nsp1 (value / 100) (default 4.25) -> maybe nsp stays for "node speed" 
|15-16|int16|nsp2 (value / 100) (default 0.5)
|17-18|int16|nsp3 (value / 100) (default 12)
|19-20|int16|mamu (value / 1E3) (default 0.033)
|21-22|int16|manu2 (value / 1E3) (default 0.028)
|23-24|int16|cst (value / 1E3) (default 0.43)
|25|int8|protocol_version


### Packet s
This packet recieves the client, whenever an other snake is in players range to let the client draw the snake.

|bytes|Data type|Description
|-----|---------|---------
|3-4|int16|snake id
|5-7|int24|snake stop ? value * Math.PI / 16777215
|8|int8|unused
|9-11|int24|value * Math.PI / 16777215 snake.eang and snake.wang maybe angels of the snake 
|12-13|int16|value / 1E3 current speed of snake
|14-16|int24|value / 16777215
|17|int8|snake skin (between 9 or 0? and 21) 
|18-20|int24|value/ 5  snake X pos
|21-23|int24|value / 5 snake Y pos
|24|int8|name lenght
|25+name lenght|string|nickname
|?|int24|I think head pos x
|?|int24|I think head pos y
|?|int8|n body part xPos
|?|int8|n body poart yPos
Body n is repeating for the amount of body parts





##Clientbound

These packets is the client sending to the server.

### Packet SetUsername
After clicking on play and recieving the "InitialPacket", the client is sending this packet

|bytes|Data type|Value|Description
|-----|---------|-----|----------
|0|int8|115|firtst id
|1|int8|5|second id
|2|int8|0-9| a random value between 0 (inclusive) and 9 (inclusive) which the clint is generating and saves in local storage
|3-?|string||the username if set


### Packet UpdateOwnSnake
This packet sends the client to the server at these client events: onMouseMove, onMouseDown, onMouseUp

|bytes|Data type|Value|Description
|-----|---------|-----|----------
|0|int8|0-250|onMouseMove: the angle (currently unknown how the real angle is calculated with this value)

|bytes|Data type|Value|Description
|-----|---------|-----|----------
|0|int8|253|onMouseDown: the snake is going in speed mode

|bytes|Data type|Value|Description
|-----|---------|-----|----------
|0|int8|254|onMouseUp: the snake is leaving the speed mode
