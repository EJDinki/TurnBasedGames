package tbg.tictactoe.game;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @author Edward Dinki
 *
 */
public class TicTacToeGame
{
    Map<String, String> cells;
    List<List<String>> board;

    String playerOne;
    String playerTwo;
    String currentTurn;

    String winningPlayer;
    boolean hasWinner;
    
    public TicTacToeGame(String playerOne, String playerTwo)
    {
        cells = new HashMap<String, String>();

        this.playerOne = playerOne;
        this.playerTwo = playerTwo;

        currentTurn = this.playerOne;
        hasWinner = false;
        winningPlayer = "";

        board = new ArrayList<List<String>>();
        for (int i = 0; i < 3; i++)
        {
            board.add(i, new ArrayList<String>());
            for (int j = 0; j < 3; j++)
            {
                board.get(i).add("");
            }
        }
        
        /*
         *     Columns
         *      0    1    2
         *rows ------------
         *   0|c1   c2   c3
         *   1|c4   c5   c6
         *   2|c7   c8   c9
         *   
         *   Diagonal 0 = c1,c5,c9
         *   Diagonal 1 = c3,c5,c7
         */
        
        addCell("c1",0,0);
        addCell("c2",0,1);
        addCell("c3",0,2);
        addCell("c4",1,0);
        addCell("c5",1,1);
        addCell("c6",1,2);
        addCell("c7",2,0);
        addCell("c8",2,1);
        addCell("c9",2,2);
    }
    
    private void addCell(String name, int row, int column)
    {
        cells.put(name, "");
        board.get(row).set(column, name);
    }
    
    public boolean resetGame(String player)
    {
        // Only one of the current players has the ability to reset the game
        if (player.equals(playerOne) || player.equals(playerTwo))
        {
            // Also currently only allowing resets after a game is over
            if (hasWinner)
            {
                for(String cell : cells.keySet())
                {
                    cells.put(cell, "");
                }
                
                hasWinner = false;
                // Loser will go first in next game.
                // Whoever is assigned to player one goes first so,
                // if the winner was player one, swap players so player two(the loser)
                // is now going first
                if (winningPlayer.equals(playerOne))
                {
                    String temp = playerOne;
                    playerOne = playerTwo;
                    playerTwo = temp;
                }
                winningPlayer = "";
                currentTurn = playerOne;
                return true;
            }
        }
        return false;
    }
    
    // Make Move
    public boolean makeMove(String player, String cell)
    {
        if (currentTurn.equals(player) && !hasWinner() && cells.containsKey(cell))
        {
            cells.put(cell, player);
            if (!checkWinner())
            {
                nextPlayer();
            }
            return true;
        }
        else
        {
            // TODO through an exception
            return false;
        }
    }
    
    private void nextPlayer()
    {
        currentTurn = currentTurn.equals(playerOne) ? playerTwo : playerOne;
    }
    
    // Get latest board config
    // Returns map of cell names -> symbols
    public Map<String, String> getBoard()
    {
        Map<String, String> board = new HashMap<String, String>();
        for (String cell : cells.keySet())
        {
            board.put(cell, getPlayerSymbol(cells.get(cell)));
        }
        return board;
    }
    
    // Get who's turn it is
    public String getCurrentTurn()
    {
        return currentTurn;
    }
    
    public boolean hasWinner()
    {
        return hasWinner;
    }    
    
    public String getWinningPlayer()
    {
        return winningPlayer;
    }

    public String getPlayerSymbol(String player)
    {
        if (player == null || player.isEmpty()) return "";
        if (player.equals(playerOne)) return "X";
        if (player.equals(playerTwo)) return "O";
        return player;
    }

    public String getCurrentTurnSymbol()
    {
        return getPlayerSymbol(currentTurn);
    }
    
    private boolean checkWinner()
    {
        // Check Rows 0,1,2
        boolean winner = false;
        for (int i = 0; i < 3; i++)
        {
            if (checkEquality(i, 0, i, 1, i, 2)) winner = true;
        }
        // Check Columns 0,1,2
        for (int i = 0; i < 3; i++)
        {
            if (checkEquality(0, i, 1, i, 2, i)) winner = true;
        }
        // Check Diagonals
        if (checkEquality(0, 0, 1, 1, 2, 2)) winner = true;
        if (checkEquality(0, 2, 1, 1, 2, 0)) winner = true;
        

        if (winner)
        {
            hasWinner = true; 
            winningPlayer = currentTurn;
            System.out.println("Player "+winningPlayer+" Won");
        }
        else if (!cells.containsValue(""))
        {
            System.out.println("Cat Won");
            hasWinner = true; 
            winningPlayer = "Cat";
        }
        
        return hasWinner;
    }
    
    private boolean checkEquality(int row1, int column1, int row2, int column2, int row3, int column3)
    {
        String playerOwningCell1 = cells.get(board.get(row1).get(column1));
        String playerOwningCell2 = cells.get(board.get(row2).get(column2));
        String playerOwningCell3 = cells.get(board.get(row3).get(column3));
        if (!playerOwningCell1.isEmpty() && !playerOwningCell2.isEmpty() && !playerOwningCell3.isEmpty() &&
            playerOwningCell1.equals(playerOwningCell2) &&
            playerOwningCell1.equals(playerOwningCell3))
        {
            System.out.println("WINNER cell coords "
                    + row1 + "," + column1
                    + row2 + "," + column2
                    + row3 + "," + column3);
            System.out.println("WINNER cell owners "
                    + "1: " + playerOwningCell1
                    + "2: " + playerOwningCell2
                    + "3:" + playerOwningCell3);
            return true;
        }
        return false;
    }

    public static void main(String[] args)
    {
        TicTacToeGame game = new TicTacToeGame("one", "two");
        System.out.println(game.getBoard());
        System.out.println("cells: " + game.cells);
        System.out.println("board: " + game.board);
        System.out.println(game.makeMove("one", "c1"));
        System.out.println(game.getBoard());
        System.out.println(game.hasWinner());
        System.out.println(game.checkWinner());
        System.out.println(game.hasWinner());
    }
}