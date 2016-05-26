# Slither.io Protocol Version 8  

Note: all values are unsigned.

## Serverbound

Every packet that comes from the server starts with a 3 byte header, which indicates the message
type. The game converts the Message Type byte to a unicode characters so I will only list the character
representations.

Most packets start like this:

<table>
  <tr>
    <th>Byte</th>
    <th>Meaning</th>
  </tr>
  <tr>
    <td>0</td><td rowspan="2">Time since last message from client</td>
  </tr>
  <tr>
    <td>1</td>
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
|e              |<a href="#type_e_detail">Snake rotation (?dir ang ?wang ?sp)</a>|
|E              |<a href="#type_E_detail">Snake rotation counterclockwise (dir wang ?sp)</a>|
|3              |<a href="#type_3_detail">Snake rotation counterclockwise (dir ang wang &#124; sp)</a>|
|4              |<a href="#type_4_detail">Snake rotation clockwise (dir wang ?sp)</a>|
|5              |<a href="#type_5_detail">Snake rotation clockwise (dir ang wang)</a>|
|h              |<a href="#type_h_detail">Update snake last body part fullness (fam)</a>|
|r              |<a href="#type_r_detail">Remove snake part</a>|
|g              |<a href="#type_g_detail">Move snake</a>|
|G              |<a href="#type_G_detail">Move snake</a>|
|n              |<a href="#type_n_detail">Increase snake</a>|
|N              |<a href="#type_N_detail">Increase snake</a>|
|l              |<a href="#type_l_detail">Leaderboard</a>|
|v              |<a href="#type_v_detail">dead/disconnect packet</a>|
|W              |<a href="#type_W_detail">Add Sector</a>|
|w              |<a href="#type_w_detail">Remove Sector</a>|
|m              |<a href="#type_m_detail">Global highscore</a>|
|p              |<a href="#type_p_detail">Pong</a>|
|u              |<a href="#type_u_detail">Update minimap</a>|
|s              |<a href="#type_s_detail">Add/remove Snake</a>|
|F              |<a href="#type_F_detail">Add Food</a>|
|b              |<a href="#type_b_detail">Add Food</a>|
|f              |<a href="#type_f_detail">Add Food</a>|
|c              |<a href="#type_c_detail">Food eaten</a>|
|j              |<a href="#type_j_detail">Update Prey</a>|
|y              |<a href="#type_y_detail">Add/remove Prey</a>|
|k              |<a href="#type_k_detail">Kill (unused in the game-code)</a>|



<a name="type_a_detail" href="#type_a_detail"><h4>Packet "a" (Initial setup)</h4></a>
Tells the Client some basic information. After the message arrives, the game calls
"startShowGame();"

|Bytes|Data Type|Description|Default|
|-----|---------|-----------|-------|
|3-5|int24|Game Radius|21600|
|6-7|int16|mscps (maximum snake length in body parts units)|411|
|8-9|int16|sector_size|480|
|10-11|int16|sector_count_along_edge (unused in the game-code)|130|
|12|int8|spangdv (value / 10)|4.8|
|13-14|int16|nsp1 (value / 100) (Maybe nsp stands for "node speed"?)|4.25|
|15-16|int16|nsp2 (value / 100)|0.5|
|17-18|int16|nsp3 (value / 100)|12|
|19-20|int16|mamu (value / 1E3)|0.033|
|21-22|int16|manu2 (value / 1E3) (angle in rad per 8ms at which prey can turn)|0.028|
|23-24|int16|cst (value / 1E3)|0.43|
|25|int8|protocol_version|Unknown|

`sct` is a snake body parts count (length) taking values between [2 .. mscps].
`fpsls[mscps]` contains snake volume (score) to snake length in body parts units.
`1/fmlts[mscps]` contains body part volume (score) to certain snake length.

Total snake score equals:

        Math.floor(15 * (fpsls[snake.sct] + snake.fam / fmlts[snake.sct] - 1) - 5) / 1

<a name="type_e_detail" href="#type_e_detail"><h4>Packet "e" (Snake rotation (?dir ang ?wang ?sp))</h4></a>

Update snake rotation direction. If packet length is 6 + 2, then rotation direction is counterclockwise:

|Bytes|Data type|Description|
|-----|---------|-----------|
|3-4|int16|Snake id|
|5|int8|ang * pi2 / 256 (current snake angle in radians, clockwise from (1, 0))|
|6|int8|wang * pi2 / 256 (target rotation angle snake is heading to)|
|7|int8|sp / 18 (snake speed?)|

If packet length is 5 + 2, then rotation defined by the angle:

|Bytes|Data type|Description|
|-----|---------|-----------|
|3-4|int16|Snake id|
|5|int8|ang * pi2 / 256 (current snake angle in radians, clockwise from (1, 0))|
|6|int8|sp / 18 (snake speed?)|

If packet length is 4 + 2, then rotation defined by the angle:

|Bytes|Data type|Description|
|-----|---------|-----------|
|3-4|int16|Snake id|
|5|int8|ang * pi2 / 256 (current snake angle in radians, clockwise from (1, 0))|

Most used packets are "e" and "4", then "5" and "3".


<a name="type_E_detail" href="#type_E_detail"><h4>Packet "E" (Snake rotation counterclockwise (dir wang ?sp))</h4></a>

Update snake rotation direction is counterclockwise. If packet length is 5 + 2, then rotation is counterclockwise:

|Bytes|Data type|Description|
|-----|---------|-----------|
|3-4|int16|Snake id|
|5|int8|wang * pi2 / 256 (target rotation angle snake is heading to)|
|6|int8|sp / 18 (snake speed?)|

If packet length is 4 + 2, then rotation is counterclockwise:

|Bytes|Data type|Description|
|-----|---------|-----------|
|3-4|int16|Snake id|
|5|int8|wang * pi2 / 256 (target rotation angle snake is heading to)|


<a name="type_3_detail" href="#type_3_detail"><h4>Packet "3" (Snake rotation counterclockwise (dir ang wang | sp))</h4></a>

Update snake rotation direction. If packet length is 5 + 2, then rotation direction is counterclockwise:

|Bytes|Data type|Description|
|-----|---------|-----------|
|3-4|int16|Snake id|
|5|int8|ang * pi2 / 256 (current snake angle in radians, clockwise from (1, 0))|
|6|int8|wang * pi2 / 256 (target rotation angle snake is heading to)|

If packet length is 4 + 2, then packet contains speed only:

|Bytes|Data type|Description|
|-----|---------|-----------|
|3-4|int16|Snake id|
|5|int8|sp / 18 (snake speed?)|

Most used packets are "e" and "4", then "5" and "3".


<a name="type_4_detail" href="#type_4_detail"><h4>Packet "4" (Snake rotation clockwise (dir wang ?sp))</h4></a>

Update snake rotation direction is clockwise.

If packet length is 5 + 2, then rotation direction is clockwise:

|Bytes|Data type|Description|
|-----|---------|-----------|
|3-4|int16|Snake id|
|5|int8|wang * pi2 / 256 (target rotation angle snake is heading to)|
|6|int8|sp / 18 (snake speed?)|

If packet length is 4 + 2, then packet contains speed only:

|Bytes|Data type|Description|
|-----|---------|-----------|
|3-4|int16|Snake id|
|5|int8|wang * pi2 / 256 (target rotation angle snake is heading to)|

Most used packets are "e" and "4", then "5" and "3".


<a name="type_5_detail" href="#type_5_detail"><h4>Packet "5" (Snake rotation clockwise (dir ang wang))</h4></a>

Update snake rotation direction is clockwise.

If packet length is 5 + 2, then rotation direction is clockwise:

|Bytes|Data type|Description|
|-----|---------|-----------|
|3-4|int16|Snake id|
|5|int8|ang * pi2 / 256 (current snake angle in radians, clockwise from (1, 0))|
|6|int8|wang * pi2 / 256 (target rotation angle snake is heading to)|

If packet length is 4 + 2, then packet contains speed only:

|Bytes|Data type|Description|
|-----|---------|-----------|
|3-4|int16|Snake id|
|5|int8|wang * pi2 / 256 (target rotation angle snake is heading to)|

Most used packets are "e" and "4", then "5" and "3".


<a name="type_h_detail" href="#type_h_detail"><h4>Packet "h" (Update snake last body part fullness (fam))</h4></a>

Update the fam-value (used for length-calculation) of a snake.
`fam` is a float value (usually in [0 .. 1.0]) representing
a body part ratio before changing snake length `sct` in body
parts. Snake gets new body part when `fam` reaches 1, and looses
1, when `fam` reaches 0.

|Bytes|Data type|Description|
|-----|---------|-----------|
|3-4|int16|Snake id|
|5-7|int24|value / 16777215 -> fam|


<a name="type_r_detail" href="#type_r_detail"><h4>Packet "r" (Remove snake part)</h4></a>

Removes the last part from this snake.

##### Variant 1: packet-size = 5

|Bytes|Data type|Description|
|-----|---------|-----------|
|3-4|int16|Snake id|

##### Variant 2: packet-size = 8

|Bytes|Data type|Description|
|-----|---------|-----------|
|3-4|int16|Snake id|
|5-7|int24|snake.fam (value / 16777215))|

<a name="type_g_detail" href="#type_g_detail"><h4>Packet "g" (Move snake)</h4></a>

Move snake into new position.

|Bytes|Data type|Description|
|-----|---------|-----------|
|3-4|int16|Snake id|
|5-6|int16|x|
|7-8|int16|y|


<a name="type_G_detail" href="#type_G_detail"><h4>Packet "G" (Move snake)</h4></a>

Move snake into new position.

|Bytes|Data type|Description|
|-----|---------|-----------|
|3-4|int16|Snake id|
|5|int8|value - 128 + head.x -> x|
|6|int8|value - 128 + head.y -> y|


<a name="type_n_detail" href="#type_n_detail"><h4>Packet "n" (Increase snake)</h4></a>

Move snake into new position and increase snake body
length by 1 body-part. The fam-value is updated.

|Bytes|Data type|Description|
|-----|---------|-----------|
|3-4|int16|Snake id|
|5-6|int16|x|
|7-8|int16|y|
|9-11|int24|value / 16777215 -> fam|


<a name="type_N_detail" href="#type_N_detail"><h4>Packet "N" (Increase snake)</h4></a>

Move snake into new position and increase snake body
length by 1 body-part. The fam-value is updated.

|Bytes|Data type|Description|
|-----|---------|-----------|
|3-4|int16|Snake id|
|5|int8|value - 128 + head.x -> x|
|6|int8|value - 128 + head.y -> y|
|7-9|int24|value / 16777215 -> fam|


<a name="type_l_detail" href="#type_l_detail"><h4>Packet "l" (Leaderboard)</h4></a>

Packet "l" is required for displaying the leaderboard.

Starting at byte 6 are the top ten players.

|Bytes|Data type|Description|
|-----|---------|-----------|
|3|int8|local players rank in leaderboard (0 means not in leaderboard, otherwise this is equal to the "local players rank". Actually always redundant information)|
|4-5|int16|local players rank|
|6-7|int16|players on server count|
|?-?|int16|J (for snake length calculation)|
|?-?|int24|I (for snake length calculation; value / 16777215)|
|?-?|int8|font color (between 0 and 8)|
|?-?|int8|username length|
|?-?|string|username|

snake length = Math.floor(150 * (fpsls[J] + I / fmlts[J] - 1) - 50) / 10;


<a name="type_v_detail" href="#type_v_detail"><h4>Packet "v" (dead/disconnect packet)</h4></a>

Sent when player died.

|Bytes|Data type|Description|
|-----|---------|-----------|
|3|int8|0-2; 0 is normal death, 1 is new highscore of the day, 2 is unknown (disconnect??)|


<a name="type_W_detail" href="#type_W_detail"><h4>Packet "W" (Add Sector)</h4></a>

Sent when a new Sector becomes active for the client.

|Bytes|Data type|Description|
|-----|---------|-----------|
|3|int8|x-coordinate of the new sector|
|4|int8|y-coordinate of the new sector|

<a name="type_w_detail" href="#type_w_detail"><h4>Packet "w" (Remove Sector)</h4></a>

Sent when a Sector should be unloaded.

|Bytes|Data type|Description|
|-----|---------|-----------|
|3|int8|x-coordinate of the sector|
|4|int8|y-coordinate of the sector|


<a name="type_m_detail" href="#type_m_detail"><h4>Packet "m" (Global highscore)</h4></a>

Packet "m" is required for displaying the global highscore

|Bytes|Data type|Description|
|-----|---------|-----------|
|3-5|int24|J (for snake length calculation)|
|6-8|int24|I (for snake length calculation; value / 16777215)|
|9|int8|The length of the winners name|
|10-?|string|Winners name|
|?-?|string|Winners message|

snake length = Math.floor(150 * (fpsls[J] + I / fmlts[J] - 1) - 50) / 10;


<a name="type_u_detail" href="#type_u_detail"><h4>Packet "u" (Update minimap)</h4></a>

Sent when the minimap is updated.

Hints for parsing the data:
* The minimap has a size of 80*80
* Start at the top-left, go to the right, when at the right, repeat for the next row and so on
* Start reading the packet at index 3
* Read one byte:
    * value >= 128: skip (value - 128) pixels
    * value < 128: repeat for every bit (from the 64-bit to the 1-bit):
        * if set, paint the current pixel
        * go to the next pixel


<a name="type_s_detail" href="#type_s_detail"><h4>Packet "s" (Add/remove Snake)</h4></a>

##### Variant 1: packet-size = 6
Sent when another snake leaves range (that is, close enough to be
drawn on screen) or dies.

|Bytes|Data type|Description|
|-----|---------|-----------|
|3-4|int16|Snake id|
|5|int8|0 (snake left range) or 1 (snake died)|

##### Variant 2: packet-size >= 31
Sent when another snake enters range.

|Bytes|Data type|Description|
|-----|---------|-----------|
|3-4|int16|Snake id|
|5-7|int24|Snake stop? value * 2*Math.PI / 16777215|
|8|int8|Unused. The 8. Byte is Unused in the game code. But the Server sends it filled with a value. Maybe we miss something here?|
|9-11|int24|value * 2*Math.PI / 16777215 snake.eang and snake.wang (Possibly angles of the snake)|
|12-13|int16|value / 1E3 current speed of snake|
|14-16|int24|value / 16777215|
|17|int8|Snake skin (between 9 or 0? and 21)|
|18-20|int24|value/ 5  snake X pos|
|21-23|int24|value / 5 snake Y pos|
|24|int8|Name length|
|25+Name length|string|Snake nickname|
|?|int24|Possibly head position (x)|
|?|int24|Possibly head position (y)|
|?|int8|Body part position (x)|
|?|int8|Body part position (y)|
The last two bytes repeat for each body part.


<a name="type_F_detail" href="#type_F_detail"><h4>Packet "F" (Add Food)</h4></a>

Sent when food that existed before enters range.

|Bytes|Data type|Description|
|-----|---------|-----------|
|3|int8|Color?|
|4-5|int16|Food X|
|6-7|int16|Food Y|
|8|int8|value / 5 -> Size|
One packet can contain more than one food-entity, bytes 3-8 (=6 bytes!) repeat for every entity.

The food id is calculated with (y * GameRadius * 3) + x


<a name="type_b_detail" href="#type_b_detail"><h4>Packet "b" (Add Food)</h4></a>

Sent when food is created while in range (because of turbo or the death of a snake).

|Bytes|Data type|Description|
|-----|---------|-----------|
|3|int8|Color?|
|4-5|int16|Food X|
|6-7|int16|Food Y|
|8|int8|value / 5 -> Size|

The food id is calculated with (y * GameRadius * 3) + x


<a name="type_f_detail" href="#type_f_detail"><h4>Packet "f" (Add Food)</h4></a>

Sent when natural food spawns while in range.

|Bytes|Data type|Description|
|-----|---------|-----------|
|3|int8|Color?|
|4-5|int16|Food X|
|6-7|int16|Food Y|
|8|int8|value / 5 -> Size|

The food id is calculated with (y * GameRadius * 3) + x


<a name="type_c_detail" href="#type_c_detail"><h4>Packet "c" (Eat Food)</h4></a>
The food id is also calculated with (y * GameRadius * 3) + x

|Bytes|Data type|Description|
|-----|---------|-----------|
|3-4|int16|Food X|
|5-6|int16|Food Y|
|7-8|int16|Eater snake id|

The packet doesn't always contain the eater snake id, in this case the food was removed for other reasons (?).


<a name="type_j_detail" href="#type_j_detail"><h4>Packet "j" (Update Prey)</h4></a>

Sent when prey ("flying particles") is updated.

|Bytes|Data type|Description|
|-----|---------|-----------|
|3-4|int16|Prey ID|
|5-6|int16|value * 3 + 1 -> x|
|7-8|int16|value * 3 + 1 -> y|

Next follow updates for one or more of these variables:

|Data type|Description|
|---------|-----------|
|int8|value - 48 -> direction (0: not turning; 1: turning counter-clockwise; 2: turning clockwise)|
|int24|value * 2*PI / 16777215 -> current angle|
|int24|value * 2*PI / 16777215 -> wanted angle (angle the prey turns towards)|
|int16|value / 1000 -> speed|

Depending on the packet-length, different variables are sent:

|packet-length|variables sent (in that exact order)|
|-------------|------------------------------------|
|11|speed|
|12|current angle|
|13|direction, wanted angle|
|14|current angle, speed|
|15|direction, wanted angle, speed|
|16|direction, current angle, wanted angle|
|18|direction, current angle, wanted angle, speed|


<a name="type_y_detail" href="#type_y_detail"><h4>Packet "y" (Add/remove Prey)</h4></a>

Sent when a Prey enters range / spawns or leaves range / gets eaten.
The exact event/format depends on the packet-length:

##### packet-length 5: remove Prey
|Bytes|Data type|Description|
|-----|---------|-----------|
|3-4|int16|Prey ID|

##### packet-length 7: eat Prey
|Bytes|Data type|Description|
|-----|---------|-----------|
|3-4|int16|Prey ID|
|5-6|int16|Eater snake ID|

##### packet-length 22: add Prey
|Bytes|Data type|Description|
|-----|---------|-----------|
|3-4|int16|Prey ID|
|5|int8|color ID|
|6-8|int24|value / 5 -> x|
|9-11|int24|value / 5 -> y|
|12|int8|value / 5 -> size|
|13|int8|value - 48 -> direction (see packet "j")|
|14-16|int24|value * 2*PI / 16777215 -> wanted angle|
|17-19|int24|value * 2*PI / 16777215 -> current angle|
|20-21|int16|value / 1000 -> speed|


<a name="type_k_detail" href="#type_k_detail"><h4>Packet "k" (Kill)</h4></a>
Note: this packet is (currently) unused in the original client, so I can only guess what the variables mean.

Sent when another snake dies by running into the player; not sent when the killer isn't the local player.

|Bytes|Data type|Description|
|-----|---------|-----------|
|3-4|int16|killer snake id|
|5-7|int24|total number of kills|



## Clientbound

All packets sent from the client contain no headers.

### Packet SetUsernameAndSkin
This packet is sent before sending the ping packet to the server. The setup packet will only be sent after receiving this and the ping packet.

|Bytes|Data type|Description|
|-----|---------|-----------|
|0|int8|First ID (always 115 = 's')|
|1|int8|Second ID (protocolVersion - 1, currently 8-1=7)|
|2|int8|Skin ID currently between 0-38 meaning 39 skins available|
|3-?|string|The client's nickname, if set|


### Packet Ping
Pings the server and ask for new data.

|Bytes|Data type|Description|
|-----|---------|-----------|
|0|int8|Value(always 251)|

### Packet UpdateOwnSnake
The client sends this packet to the server when it receives a mouseMove, mouseDown, mouseUp, keyDown or keyUp event.

|Bytes|Data type|Value|Description|
|-----|---------|-----|-----------|
|0|int8|0-250|mouseMove: the input angle. Counter-clockwise, (0 and 250 point right, 62 points up)|
|0|int8|252|keyDown, keyUp (left-arrow or right-arrow): start/stop turning left or right|
|0|int8|253|mouseDown, keyDown (space or up-arrow): the snake is entering speed mode|
|0|int8|254|mouseUp, keyUp (space or up-arrow): the snake is leaving speed mode|
|1|int8|0-255|unknown, only used if first byte is 252|

angle in radians = value * pi/125

### Packet SaveVictoryMessage
When you have the longest snake of the day, you're able to send a victory message.

|Bytes|Data type|Description|
|-----|---------|-----------|
|0|int8|First ID (always 255)|
|1|int8|Second ID (always 118)|
|2-?|string|The victory message|
