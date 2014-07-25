<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <script src="http://ajax.googleapis.com/ajax/libs/jquery/2.1.0/jquery.min.js"></script>
<title>TicTacToe</title>

<script type="text/javascript" language="javascript">
var turn = -1;
var xWon = 0;
var oWon = 0;
var catsGame = 0;
var cells;
function makeCells(){
	console.log("Making Cells");
    cells = new Array($("#c1"), $("#c2"), $("#c3"), $("#c3"), $("#c4"), $("#c5"), $("#c6"), $("#c7"), $("#c8"), $("#c9"));
}

/*
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
*/

$(document).ready(function()
{
    updateBoard();
    window.setInterval(updateBoard, 1000);
});

var updateBoard = function()
{
    //return; // REMOVE THIS
    $.ajax({
        type: "GET",
        url: "/tbg/TicTacToe?update=true", 
        success: function(json) {
            $.each(json, function(i, val) {
                       $("#" + i).val(val);
            });
        	if ("waitingForPlayers" in json)
        	{
        	    $("#playerSymbol").html("");
        	    $("#currentTurn").html("Waiting for another Player.");
        	    $("#winningPlayer").html("Please wait...");
        	}
        	else
        	{
                $("#playerSymbol").html("Playing as " + json.playerSymbol + "'s");
                $("#currentTurn").html("Currently " + json.currentTurn + "'s Turn");
                if ("winningPlayer" in json)
                {
                    $("#winningPlayer").html(json.winningPlayer + " Won!");
                }
                else
                {
                    $("#winningPlayer").html("");
                }
        	}
        	// Here we read json and set appropriate buttons
        	// indicate whos turn it is, set currentTurn span

        	//updateBoard();
        },
        error: function(err) {
            console.log('Error:\n' + err.responseText + '  Status:\n' + err.status);
        }
    });
};

function move(cell){
    if (cell.value == '')
    {
        $.ajax({
            type: "POST",
            url: "/tbg/TicTacToe", 
            data: { cell: cell.id },
            success: function(json) {
                if (json.response == "OK")
                {
                	updateBoard();
                    //var myCell = $("input[name='"+cell.name+"']").val("X");
                    //cells[1].val("X"); // An alternative way to set the value, assuming we know the index
                    //cell.value = json.symbol;
                }
                else if(json.response == "IS_OBSERVER")
                {
                	alert("You are currently an observer and cannot play.")
                }
            /*
            var chat = $("#chat");
                chat.empty();
            var messages = json.messages;
                messages.forEach(function(message) {
                    chat.append(message);
                    chat.append("<br>");
                });
                var scrollChat = document.getElementById("chat");
                scrollChat.scrollTop = scrollChat.scrollHeight;
            */
            },
            error: function(err) {
                console.log('Error:' + err.responseText + '  Status: ' + err.status);
            }
        });
    }
}

function reset(){
    $.ajax({
        type: "POST",
        url: "/tbg/TicTacToe", 
        data: { reset: true },
        success: function(json) {
            if (json.response == "OK")
            {
                updateBoard();
                //var myCell = $("input[name='"+cell.name+"']").val("X");
                //cells[1].val("X"); // An alternative way to set the value, assuming we know the index
                //cell.value = json.symbol;
            }
            if (json.response == "UNSUCCESSFUL")
            {
            	alert("Unable to reset game");
            }
        },
        error: function(err) {
            console.log('Error:' + err.responseText + '  Status: ' + err.status);
        }
    });
}

/* This is generic code to get a cookie of a given name.
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
*/
</script>

<style type="text/css">
body {
 color:black;
 background-color:white;
 font-family:Tahoma,Verdana,Helvetica,Arial,sans-serif;
}
.cell {
 background-color:white;
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
 border:thick black outset;
}
.board {
 border:thin black ridge;
 background-color:darkgray;
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
<body onload="makeCells();">

<noscript>&lt;p style="color:red;"&gt;You must enable javascript to be able to play tic-tac-toe.&lt;/p&gt;</noscript>
<h1>TicTacToe</h1>
<h3><span id="playerSymbol"></span></h3>
<h3><span id="currentTurn"></span></h3>
<h3><span id="winningPlayer" style="color: red;"></span></h3>

<table class="board" cellspacing="6">
<tbody><tr>
 <td class="cell"><input class="cell" id="c1" type="button" accesskey="1" onclick="move(this);" value="" style="background-color: lightgray;"></td>
 <td class="cell"><input class="cell" id="c2" type="button" accesskey="2" onclick="move(this);" value="" style="background-color: lightgray;"></td>
 <td class="cell"><input class="cell" id="c3" type="button" accesskey="3" onclick="move(this);" value="" style="background-color: lightgray;"></td>
</tr><tr>
 <td class="cell"><input class="cell" id="c4" type="button" accesskey="4" onclick="move(this);" value="" style="background-color: lightgray;"></td>
 <td class="cell"><input class="cell" id="c5" type="button" accesskey="5" onclick="move(this);" value="" style="background-color: lightgray;"></td>
 <td class="cell"><input class="cell" id="c6" type="button" accesskey="6" onclick="move(this);" value="" style="background-color: lightgray;"></td>
</tr><tr>
 <td class="cell"><input class="cell" id="c7" type="button" accesskey="7" onclick="move(this);" value="" style="background-color: lightgray;"></td>
 <td class="cell"><input class="cell" id="c8" type="button" accesskey="8" onclick="move(this);" value="" style="background-color: lightgray;"></td>
 <td class="cell"><input class="cell" id="c9" type="button" accesskey="9" onclick="move(this);" value="" style="background-color: lightgray;"></td>
</tr>
</tbody></table>
<input type="button" onclick="reset();" value="Reset Game" ></input>
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