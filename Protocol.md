### Slither.io Protocol Version 6

##### From Server

Every Message that comes from the Server starts with 3 byte. These first 3 byte are the Message Type (The game converts the bytes to an unicode char so i will only speak of the chars not the byte values).

The Most messages starts as following:

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
