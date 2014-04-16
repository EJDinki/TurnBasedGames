package tbg.tictactoe.game;

import java.util.HashMap;
import java.util.Map;

/**
 * @author Edward Dinki
 *
 */
public class TicTacToeGameManager
{
    
    // Player IDs -> Games
    Map<String, TicTacToeGame> games;
    String waitingPlayer;
    
    public TicTacToeGameManager()
    { 
        games = new HashMap<String, TicTacToeGame>();
    }
    
    public void createGame(String playerId)
    {
        // See if this player has a currently running Game
        /*
        if (games.containsKey(playerId))
        {
            System.out.println("contains player: " + playerId);
            // Delete the other player in the game
            // This could probably be cleaned up a bit more
            TicTacToeGame game = games.get(playerId);
            games.remove(playerId);
            for (String player : games.keySet())
            {
                if (games.get(player) == game)
                {
                    games.remove(player);
                    break;
                }
            }
        }
        */
        // If there is no waiting players, this player becomes the waiting player
        if (waitingPlayer == null)
        {
            System.out.println("Player waiting: " + playerId);
            waitingPlayer = playerId;
        }
        // If there is a waiting player, create a game for the waiting player and this player
        else
        {
            TicTacToeGame game = new TicTacToeGame(waitingPlayer, playerId);
            games.put(waitingPlayer, game);
            games.put(playerId, game);
            waitingPlayer = null;
        }
    }

    public TicTacToeGame getGame(String playerId)
    {
        return games.get(playerId);
    }

    public boolean gameHasBeenCreated(String playerId) throws InvalidGameException
    {
       if (games.containsKey(playerId)) return true;
       if (waitingPlayer != playerId)
       {
           System.out.println("gameHasBeenCreated invalid exception");
           //throw new InvalidGameException();
       }
       return false;
    }
    
    // TODO make these else returns exception throws

    public boolean resetGame(String player)
    {
        if (games.containsKey(player))
        {
            return games.get(player).resetGame(player);
        }
        return false;
    }

    public boolean makeMove(String player, String cell)
    {
        if (games.containsKey(player))
        {
            return games.get(player).makeMove(player, cell);
        }
        return false;
    }
    
    public Map<String, String> getBoard(String player)
    {
        if (games.containsKey(player))
        {
            return games.get(player).getBoard();
        }
        return null;
    }
    
    // Block waiting for changes. Return if changes or timeout
    // Timeout in seconds
    public int waitForChanges(String player, int timeout, int series) throws InvalidGameException
    {
        for (int i = 0; i < timeout; i++)
        {
            if (games.containsKey(player))
            {
                int gameSeries = games.get(player).getSeries();
                if (gameSeries > series)
                {
                    return gameSeries;
                }

                try
                {
                    Thread.sleep(100);
                }
                catch (InterruptedException e)
                {
                    break;
                }
            }
            else
            {
                System.out.println("waitForChanges invalid exception");
                //throw new InvalidGameException();
                //return series;
            }
        }
        return series;
    }

    public String getPlayerSymbol(String player)
    {
        if (games.containsKey(player))
        {
            return games.get(player).getPlayerSymbol(player);
        }
        return null;
    }
    
    public String getCurrentTurnSymbol(String player)
    {
        if (games.containsKey(player))
        {
            return games.get(player).getCurrentTurnSymbol();
        }
        return null;
    }

    public String getCurrentTurn(String player)
    {
        if (games.containsKey(player))
        {
            return games.get(player).getCurrentTurn();
        }
        return null;
    }
    
    public boolean hasWinner(String player)
    {
        if (games.containsKey(player))
        {
            return games.get(player).hasWinner();
        }
        return false;
    }    
    
    public String getWinningPlayer(String player)
    {
        if (games.containsKey(player))
        {
            return games.get(player).getWinningPlayer();
        }
        return "";
    }

    public String getWinningPlayerSymbol(String player)
    {
        if (games.containsKey(player))
        {
            return games.get(player).getPlayerSymbol(getWinningPlayer(player));
        }
        return "";
    }

}
