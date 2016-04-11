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
|v|-|
|w|-|
|m|-|
|p|-|
|u|-|
|s|-|
|F|-|
|b,f|-|
|c|-|
|j|-|
|y|-|


## Serverbound

(Bytes are 0 based)

### Packet a
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
New Snake

|bytes|Data type|Description
|-----|---------|---------
|3-4|int16|snake id
|5-7|int24|snake stop ? value * Math.PI / 16777215
|8|int9|unused
|9-11|int24|value * Math.PI / 16777215 snake.eang and snake.wang maybe angels of the snake 
|12-13|int16|value / 1E3 initial speed
|14-16|int24|value / 16777215
|17|int8|snake skin (between 9 and 21) 
|18-20|int24|value/ 5  snake X pos
|21-23|int24|value / 5 snake Y pos
|24|int8|name lenght
|25+name lenght|string|nickname
|?+?|?|arguments something with the parts (body parts of the snake) 

//sry im to tiered the byte numbers are not 100% correct. I'll fix dem tommorow
