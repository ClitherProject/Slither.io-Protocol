### Slither.io Protocol Version 6

##### From Server

Every Packet that comes from the Server starts with 3 byte. These first 3 byte are the Message Type (The game converts the bytes to an unicode char so i will only speak of the chars not the byte values).

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
     <td colspan="3">msg type</td>
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


