# Slither.io Protocol Version 6

## From Server

Every packet that comes from the server starts with a 3 byte header, which indicates the message
type. The game converts the bytes to unicode characters so I will only list the character
representations.

Most packets start like this:

<table>
  <tr>
    <th>Byte</th>
    <th>Meaning</th>
  </tr>
  <tr>
    <td>0</td><td>Unknown</td>
  </tr>
  <tr>
    <td>1</td><td>Unknown</td>
  </tr>
  <tr>
    <td>2</td><td><a href="#typetable">Message Type</a></td>
  </tr>
  <tr>
    <td>3</td><td rowspan="2">Snake ID</td>
  </tr>
  <tr>
    <td>4</td>
  </tr>
 </table>


<a name="typetable" href="#typetable"><h3>Message Types</h3></a>
|Type Identifier|Meaning|
|---------------|-------|
|a              |<a href="#type_a_detail">Initial setup</a>|
|e,E,3,4,5      |Unknown|
|h              |Snake "fam" variable|
|r              |Maybe snake parts?|
|g,n,G,N        |<a href="#type_g_detail">Snake update</a>|
|l              |Unknown|
|v              |dead/disconnect packet|
|w              |Unknown|
|m              |Global score|
|p              |Ping/pong|
|u              |Food on minimap?|
|s              |<a href="#type_s_detail">New snake</a>|
|F              |Related to new food particles spawning|
|b,f            |Related to new food particles spawning|
|c              |Food eaten?|
|j              |Something related to prey (possibly flying food particles)|
|y              |New prey|

<a name="type_a_detail" href="#type_a_detail"><h4>Packet "a" (Initial setup)</h4></a>
Tells the Client some basic information. After the message arrives, the game calls
"startShowGame();"

|Bytes|Data Type|Description|Default|
|-----|---------|-----------|-------|
|3-5|int24|Game Radius|21600|
|6-7|int16|setMscps(value)? setMscps is used to fill the arrays fmlts and fpsls. But IDK for what they are.|411|
|8-9|int16|sector_size|480|
|10-11|int16|sector_count_along_edge|130|
|12|int8|spangdv (value / 10)|4.8|
|13-14|int16|nsp1 (value / 100) (Maybe nsp stands for "node speed"?)|4.25|
|15-16|int16|nsp2 (value / 100)|0.5|
|17-18|int16|nsp3 (value / 100)|12|
|19-20|int16|mamu (value / 1E3)|0.033|
|21-22|int16|manu2 (value / 1E3)|0.028|
|23-24|int16|cst (value / 1E3)|0.43|
|25|int8|protocol_version|Unknown|


<a name="type_s_detail" href="#type_s_detail"><h4>Packet "s" (New snake)</h4></a>
The client receives this packet whenever another snake is in range (that is, close enough to be
drawn on screen).

|Bytes|Data type|Description|
|-----|---------|-----------|
|3-4|int16|Snake id|
|5-7|int24|Snake stop? value * Math.PI / 16777215|
|8|int8|Unused|
|9-11|int24|value * Math.PI / 16777215 snake.eang and snake.wang (Possibly angles of the snake)|
|12-13|int16|value / 1E3 current speed of snake|
|14-16|int24|value / 16777215|
|17|int8|Snake skin (between 9 or 0? and 21)|
|18-20|int24|value/ 5  snake X pos|
|21-23|int24|value / 5 snake Y pos|
|24|int8|Name length|
|25+Name length|string|Snake nickname
|?|int24|Possibly head position (x)
|?|int24|Possibly head position (y)
|?|int8|Body part position (x)
|?|int8|Body part position (y)
The last two bytes repeat for each body part.

<a name="type_g_detail" href="#type_g_detail"><h4>Packets "g", "G", "n", and "N" (Snake
update)</h4></a>

If the message type is "n" or "N", the snake sct is increased by one. Otherwise, all body parts are
marked as dying.

|Bytes|Data type|Description|
|-----|---------|-----------|
|3-4|int16|Snake id|
|5-6|int16|New or last nody part x|
|7-8|int16|New or last body part y|
|9-11|int24|snake.fam (value / 16777215) (only if packet is n or N)|



## From Client

All packets sent from the client contain no headers.

### Packet SetUsername
After clicking Play and receiving the initial response packet, the client sends the following
packet:

|Bytes|Data type|Description|
|-----|---------|-----------|
|0|int8|First id (always 115)|
|1|int8|Second id (always 5)|
|2|int8|A random value in {0, 9} (inclusive) which the client generates and saves|
|3-?|string|The client's nickname, if set|


### Packet UpdateOwnSnake
The client sends this packet to the server when it receives a mouseMove, mouseDown, or mouseUp
event.

|Bytes|Data type|Value|Description|
|-----|---------|-----|-----------|
|0|int8|0-250|mouseMove: the angle (currently unknown how the real angle is calculated with this value)|
|0|int8|253|onMouseDown: the snake is entering speed mode|
|0|int8|254|onMouseUp: the snake is leaving speed mode|
