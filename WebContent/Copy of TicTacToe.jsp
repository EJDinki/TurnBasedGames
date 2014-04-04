<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
    <script src="http://ajax.googleapis.com/ajax/libs/jquery/2.1.0/jquery.min.js"></script>
<title>TicTacToe</title>

<script type="text/javascript" language="javascript">
var turn = -1;
var xWon = 0;
var oWon = 0;
var catsGame = 0;
var cells;
function makeCells(){
    var b = document.board;
    cells = new Array(b.c1,b.c2,b.c3,b.c4,b.c5,b.c6,b.c7,b.c8,b.c9)
}

function loadStats(){
    var cookie = getCookie('tictactoeStats');
    if (cookie != null && cookie.length > 1){
        var stats = cookie.substring(1,cookie.length);
        if (stats != null){
            var statsSplit = stats.split(':');
            var temp;
            if (statsSplit.length == 3){
                var re = new RegExp("^([0-9]*)$");
                if (re.test(statsSplit[0])) xWon = eval(statsSplit[0]);
                if (re.test(statsSplit[1])) oWon = eval(statsSplit[1]);
                if (re.test(statsSplit[2])) catsGame = eval(statsSplit[2]);
                drawStats();
            }
        }
    }
}

function nextTurn(){
    turn = -turn;
    if (turn == 1){
        if(document.board.p1.selectedIndex == 1) beginnerMove();
        if(document.board.p1.selectedIndex == 2) intermediateMove();
        if(document.board.p1.selectedIndex == 3) experiencedMove();
        if(document.board.p1.selectedIndex == 4) perfectMove();
    } else {
        if(document.board.p2.selectedIndex == 1) beginnerMove();
        if(document.board.p2.selectedIndex == 2) intermediateMove();
        if(document.board.p2.selectedIndex == 3) experiencedMove();
        if(document.board.p2.selectedIndex == 4) perfectMove();
    }
}

function getLegalMoves(state){
    var moves = 0;
    for (var i=0; i<9; i++){
        if ((state & (1<<(i*2+1))) == 0){
            moves |= 1 << i;
        }
    }
    return moves;
}

function moveRandom(moves){
    var numMoves = 0;
    for (var i=0; i<9; i++){
        if ((moves & (1<<i)) != 0) numMoves++;
    }
    if (numMoves > 0){
        var moveNum = Math.ceil(Math.random()*numMoves);
        numMoves = 0;
        for (var j=0; j<9; j++){
            if ((moves & (1<<j)) != 0) numMoves++;
            if (numMoves == moveNum){
                move(cells[j]);
                return;
            }
        }
    }
}

function openingBook(state){
    var mask = state & 0x2AAAA; 
    if (mask == 0x00000) return 0x1FF;
    if (mask == 0x00200) return 0x145;
    if (mask == 0x00002 ||
        mask == 0x00020 ||
        mask == 0x02000 ||
        mask == 0x20000) return 0x010;
    if (mask == 0x00008) return 0x095;
    if (mask == 0x00080) return 0x071;
    if (mask == 0x00800) return 0x11C;
    if (mask == 0x08000) return 0x152;
    return 0;
}

function perfectMove(){
    var state = getState();
    var winner = detectWin(state);
    if (winner == 0){
        var moves = getLegalMoves(state);
        var hope = -999;
        var goodMoves = openingBook(state);
        if (goodMoves == 0){
            for (var i=0; i<9; i++){
                if ((moves & (1<<i)) != 0) {
                    var value = moveValue(state, i, turn, turn, 15, 1);
                    if (value > hope){
                        hope = value;
                        goodMoves = 0;
                    }
                    if (hope == value){
                        goodMoves |= (1<<i);
                    }
                }
            }
        }
        moveRandom(goodMoves);
    }
}

function moveValue(istate, move, moveFor, nextTurn, limit, depth){
    var state = stateMove(istate, move, nextTurn);
    var winner = detectWin(state);
    if ((winner & 0x300000) == 0x300000){
        return 0;
    } else if (winner != 0){
        if (moveFor == nextTurn) return 10 - depth;
        else return depth - 10;
    }
    var hope = 999;
    if (moveFor != nextTurn) hope = -999;
    if(depth == limit) return hope;
    var moves = getLegalMoves(state);
    for (var i=0; i<9; i++){
        if ((moves & (1<<i)) != 0) {
            var value = moveValue(state, i, moveFor, -nextTurn, 10-Math.abs(hope), depth+1);
            if (Math.abs(value) != 999){
                if (moveFor == nextTurn && value < hope){
                    hope = value;
                } else if (moveFor != nextTurn && value > hope){
                    hope = value;
                }
            }
        }
    }
    return hope;
}

function detectWinMove(state, cellNum, nextTurn){
    var value = 0x3;
    if (nextTurn == -1) value = 0x2;
    var newState = state | (value << cellNum*2);
    return detectWin(newState);
}

function beginnerMove(){
    var state = getState();
    var winner = detectWin(state);
    if (winner == 0) moveRandom(getLegalMoves(state));
}

function getGoodMove(state){
    var moves = getLegalMoves(state);
    for (var i=0; i<9; i++){
        if ((moves & (1<<i)) != 0) {
            if (detectWinMove(state, i, turn)){
                move(cells[i]);
                return 0;
            }
        }
    }
    for (var j=0; j<9; j++){
        if ((moves & (1<<j)) != 0) {
            if (detectWinMove(state, j, -turn)){
                move(cells[j]);
                return 0;
            }
        }
    }
    return moves;
}


function intermediateMove(){
    var state = getState();
    var winner = detectWin(state);
    if (winner == 0) {
        moveRandom(getGoodMove(state));
    }
}

function experiencedMove(){
    var state = getState();
    var winner = detectWin(state);
    if (winner == 0) {
        var moves = openingBook(state);
        if (state == 0) moves = 0x145;
        if (moves == 0) moves = getGoodMove(state);
        moveRandom(moves);
    }
}

function getState(){
    var state = 0;
    for (var i=0; i<9; i++){
        var cell = cells[i];
        var value = 0;
        if (cell.value.indexOf('X') != -1) value = 0x3;
        if (cell.value.indexOf('O') != -1) value = 0x2;
        state |= value << (i*2);
    }
    return state;
}

function detectWin(state){
    if ((state & 0x3F000) == 0x3F000) return 0x13F000;
    if ((state & 0x3F000) == 0x2A000) return 0x22A000;
    if ((state & 0x00FC0) == 0x00FC0) return 0x100FC0;
    if ((state & 0x00FC0) == 0x00A80) return 0x200A80;
    if ((state & 0x0003F) == 0x0003F) return 0x10003F;
    if ((state & 0x0003F) == 0x0002A) return 0x20002A;
    if ((state & 0x030C3) == 0x030C3) return 0x1030C3;
    if ((state & 0x030C3) == 0x02082) return 0x202082;
    if ((state & 0x0C30C) == 0x0C30C) return 0x10C30C;
    if ((state & 0x0C30C) == 0x08208) return 0x208208;
    if ((state & 0x30C30) == 0x30C30) return 0x130C30;
    if ((state & 0x30C30) == 0x20820) return 0x220820;
    if ((state & 0x03330) == 0x03330) return 0x103330;
    if ((state & 0x03330) == 0x02220) return 0x202220;
    if ((state & 0x30303) == 0x30303) return 0x130303;
    if ((state & 0x30303) == 0x20202) return 0x220202;
    if ((state & 0x2AAAA) == 0x2AAAA) return 0x300000;
    return 0;
}

function recordWin(winner){
    if ((winner & 0x300000) == 0x100000){
        xWon++;
    } else if ((winner & 0x300000) == 0x200000){
        oWon++;
    } else if ((winner & 0x300000) == 0x300000){
        catsGame++;
    }
    drawStats();
}

function drawStats(){
    var b = document.board;
    var totalGames = xWon + oWon + catsGame;
    b.xWon.value = xWon;
    b.oWon.value = oWon;
    b.catsGame.value = catsGame;
    b.xWonPer.value = ((xWon==0)?0:(Math.round(xWon * 1000 / totalGames) / 10)) + '%';
    b.oWonPer.value = ((oWon==0)?0:(Math.round(oWon * 1000 / totalGames) / 10)) + '%';
    b.catsGamePer.value = ((catsGame==0)?0:(Math.round(catsGame * 1000 / totalGames) / 10)) + '%';
    var cookie = ':' + xWon + ':' + oWon + ':' + catsGame;
    var expires = new Date();
    // cookie expires in one year
    expires.setTime(expires.getTime() + 365 * 24 * 60 * 60 * 1000);
    document.cookie = (
        'tictactoeStats' + '=' +
        escape(cookie) +
        '; expires=' + expires.toGMTString()
    );
}

function clearStats(){
    xWon = 0;
    oWon = 0;
    catsGame = 0;
    drawStats();
}

function drawState(state){
    var winner = detectWin(state);
    if ((winner & 0x300000) != 0){
        if ((winner & 0x300000) == 0x100000){
            xWon++;
        } else if ((winner & 0x300000) == 0x200000){
            oWon++;
        } else {
            catsGame++;
        }
        drawStats();
    }
    for (var i=0; i<9; i++){
        var value = '';
        if ((state & (1<<(i*2+1))) != 0){
            if ((state & (1<<(i*2))) != 0){
                value = 'X';
            } else {
                value = 'O';
            }
        }
        if ((winner & (1<<(i*2+1))) != 0){
            if (cells[i].style){
                cells[i].style.backgroundColor='red';
            } else {
                value = '*' + value + '*';
            }
        } else {
            if (cells[i].style){
                cells[i].style.backgroundColor='green';
            }
        }
        cells[i].value = value;
    }
}

function stateMove(state, move, nextTurn){
    var value = 0x3;
    if (nextTurn == -1) value = 0x2;
    return (state | (value << (move*2)));
}

function move(cell){
    if (cell.value == ''){
        var state = getState();
        var winner = detectWin(state);
        if (winner == 0){
            for (var i=0; i<9; i++){
                if (cells[i] == cell){
                    state = stateMove(state, i, turn);
                }
            }
            drawState(state);
            nextTurn();
        }
    }
}
function countMoves(state){
    var count = 0;
    for (var i=0; i<9; i++){
        if ((state & (1<<(i*2+1))) != 0){
           count++;
        }
    }
    return count;
}

function newGame(){
    var state = getState();
    var winner = detectWin(state);
    if (winner == 0 && countMoves(state) > 1){
        if (turn == 1) oWon++;
        else xWon++;
        drawStats();
    }
    drawState(0);
    if (document.board.firstMove[0].checked=='1'){
        turn = -1;
    } else {
        turn = 1;
    }
    nextTurn();
}

function getCookie(name) {
  var prefix = name + "=";
  var begin = document.cookie.indexOf("; " + prefix);
  if (begin == -1) {
    begin = document.cookie.indexOf(prefix);
    if (begin != 0) return null;
  } else
    begin += 2;
  var end = document.cookie.indexOf(";", begin);
  if (end == -1)
    end = document.cookie.length;
  return unescape(document.cookie.substring(begin + prefix.length, end));
}
</script>

<style type="text/css">
body {
 color:black;
 background-color:white;
 font-family:Tahoma,Verdana,Helvetica,Arial,sans-serif;
}
.cell {
 background-color:green;
 color:white;
 font-size:2cm;
 font-family:Courier New,Courier,monospaced;
 font-weight:bold;
}
input.cell {
 border:none;
 width:2cm;
 vertical-align:bottom;
}
td.cell {
 border:thick green outset;
}
.board {
 border:thin black ridge;
 background-color:green;
 margin-right:1cm;
}
.winstat {
 color:black;
 background-color:white;
 border:none;
}
.player {
 font-family:Courier New,Courier,monospaced;
 font-weight:bold;
 font-size:150%;
}
</style>

<style type="text/css"></style></head>
<body onload="makeCells();loadStats();newGame();">

<noscript>&lt;p style="color:red;"&gt;You must enable javascript to be able to play tic-tac-toe.&lt;/p&gt;</noscript>
<h1>TicTacToe</h1>

<table class="board" cellspacing="6">
<tbody><tr>
 <td class="cell"><input class="cell" name="c7" type="button" accesskey="7" onclick="move(this);" value="" style="background-color: green;"></td>
 <td class="cell"><input class="cell" name="c8" type="button" accesskey="8" onclick="move(this);" value="" style="background-color: green;"></td>
 <td class="cell"><input class="cell" name="c9" type="button" accesskey="9" onclick="move(this);" value="" style="background-color: green;"></td>
</tr><tr>
 <td class="cell"><input class="cell" name="c4" type="button" accesskey="4" onclick="move(this);" value="" style="background-color: green;"></td>
 <td class="cell"><input class="cell" name="c5" type="button" accesskey="5" onclick="move(this);" value="" style="background-color: green;"></td>
 <td class="cell"><input class="cell" name="c6" type="button" accesskey="6" onclick="move(this);" value="" style="background-color: green;"></td>
</tr><tr>
 <td class="cell"><input class="cell" name="c1" type="button" accesskey="1" onclick="move(this);" value="" style="background-color: green;"></td>
 <td class="cell"><input class="cell" name="c2" type="button" accesskey="2" onclick="move(this);" value="" style="background-color: green;"></td>
 <td class="cell"><input class="cell" name="c3" type="button" accesskey="3" onclick="move(this);" value="" style="background-color: green;"></td>
</tr>
</tbody></table>

</br>

<table border="1" cellpadding="3">
<tbody><tr>
<th>Player</th>
<th>First</th>
<th>Type</th>
<th>Wins</th>
<th>Record</th>
</tr><tr>
<th class="player">X</th>
<td><input type="radio" name="firstMove" value="X" checked="" onchange="newGame();"></td>
<td><select name="p1" onchange="newGame()">
<option value="1" selected="">Human
</option><option value="2">Novice
</option><option value="3">Intermediate
</option><option value="4">Experienced
</option><option value="5">Expert
</option></select></td>
<td align="right"><input type="button" name="xWon" class="winstat" value="1"></td>
<td align="right"><input type="button" name="xWonPer" class="winstat" value="50%"></td>
</tr><tr>
<th class="player">O</th>
<td><input type="radio" name="firstMove" value="O" onchange="newGame();"></td>
<td><select name="p2" onchange="newGame()">
<option value="1">Human
</option><option value="2">Novice
</option><option value="3" selected="">Intermediate
</option><option value="4">Experienced
</option><option value="5">Expert
</option></select></td>
<td align="right"><input type="button" name="oWon" class="winstat" value="0"></td>
<td align="right"><input type="button" name="oWonPer" class="winstat" value="0%"></td>
</tr><tr>
<th>Cat</th>
<td></td>
<td></td>
<td align="right"><input type="button" name="catsGame" class="winstat" value="1"></td>
<td align="right"><input type="button" name="catsGamePer" class="winstat" value="50%"></td>
</tr></tbody></table>
<p align="left"><input type="button" name="newgame" value="Clear Stats" accesskey="c" onclick="clearStats();"></p>
<p align="left"><input type="button" name="newgame" value="New Game" accesskey="n" onclick="newGame();"></p><p>
</p>

    <!-- var foo = get chat div. food.scrollTop = foo.scrollHeight -->
    <!--
    $(document).ready(function()
    {
        $("#submitbtn").click(function(){
        	submitText();
    	});

    	updateChat();
    	window.setInterval(updateChat, 500);

    	$('#chatInput').keypress(function (e) {
    	    var code = e.keyCode || e.which;
    	    if (code === 13) {
    	        //enter has been pressed
    	        submitText();
    	    };
    	});

    });
    var submitText = function()
    {
            var textBox = $("#chatInput");
        	$.ajax({
                type: "POST",
                url: "/chat/ChatServlet", 
                data: { message: textBox.val()},
                //dataType: "json",
                success: function(json) {
                textBox.val("");
                var chat = $("#chat");
            	chat.empty();
                var messages = json.messages;
                messages.forEach(function(message) {
                	chat.append(message);
                	chat.append("<br>");
                });
        	      var scrollChat = document.getElementById("chat");
        	      scrollChat.scrollTop = scrollChat.scrollHeight;
                },
                error: function(err) {
                    console.log('Error:' + err.responseText + '  Status: ' + err.status);
                }
            });
    };

    var updateChat = function()
    {
        $.ajax({
            type: "GET",
            url: "/chat/ChatServlet", 
            //contentType: "text/html; charset=utf-8",
            success: function(json) {
            	var chat = $("#chat");
            	chat.empty();
                var messages = json.messages;
                messages.forEach(function(message) {
                	chat.append(message);
                	chat.append("<br>");
                });
            	var scrollChat = document.getElementById("chat");
            	scrollChat.scrollTop = scrollChat.scrollHeight;
            },
            error: function(err) {
            	   console.log('Error:\n' + err.responseText + '  Status:\n' + err.status);
            }
        });
    };
    -->
</html>