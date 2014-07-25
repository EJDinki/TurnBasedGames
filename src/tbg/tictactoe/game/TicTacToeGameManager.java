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
        // If there is no waiting players, this player becomes the waiting player
        if (waitingPlayer == null)
        {
            // See if this player has a currently running Game
            if (games.containsKey(playerId))
            {
                games.get(playerId);// TODO invalidate this game
                games.remove(playerId);
            }
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

    public boolean gameHasBeenCreated(String playerId)
    {
       return games.containsKey(playerId);
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
