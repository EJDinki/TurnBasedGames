/**
 * 
 */
package tbg.tictactoe.servlets;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Queue;

import javax.servlet.AsyncContext;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.simple.JSONObject;

import tbg.tictactoe.game.TicTacToeGame;
import tbg.tictactoe.game.TicTacToeGameManager;

/**
 * @author Edward Dinki
 *
 */
public class TicTacToeServlet extends HttpServlet {
    
    private static final long serialVersionUID = 5402169147192456628L;
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String sessionId = request.getSession().getId();
        TicTacToeGameManager gameManager = (TicTacToeGameManager) getServletContext().getAttribute("TicTacToeGameManager");
        
        // If they want a board update send it to them
        if (request.getParameter("update") != null)
        {
            /*
            if (gameManager.gameHasBeenCreated(sessionId))
            {
                AsyncContext aCtx = request.startAsync(request, response); 
                ServletContext appScope = request.getServletContext();    
                Map<TicTacToeGame, List<AsyncContext>> watchers = (Map<TicTacToeGame, List<AsyncContext>>)appScope.getAttribute("watchers");
                List<AsyncContext> gameWatchers = (List<AsyncContext>)watchers.get(gameManager.getGame(sessionId));
                if (gameWatchers == null)
                {
                    gameWatchers = new ArrayList<AsyncContext>();
                    watchers.put(gameManager.getGame(sessionId), gameWatchers);
                }
                gameWatchers.add(aCtx); // register a watcher
            }
            else
            {
                response.setContentType("application/json");
                PrintWriter out = response.getWriter();
                JSONObject json = new JSONObject();
                json.put("waitingForPlayers", true);
                out.print(json);
                out.close();
                return;
            }
            */
            response.setContentType("application/json");
            PrintWriter out = response.getWriter();
            JSONObject json = new JSONObject();
            if (gameManager.gameHasBeenCreated(sessionId))
            {
                if (!gameManager.getWinningPlayer(sessionId).isEmpty())
                {
                    json.put("winningPlayer", gameManager.getWinningPlayerSymbol(sessionId));
                }
                json.putAll(gameManager.getBoard(sessionId));
                json.put("currentTurn", gameManager.getCurrentTurnSymbol(sessionId));
                json.put("playerSymbol", gameManager.getPlayerSymbol(sessionId));
            }
            else
            {
                json.put("waitingForPlayers", true);
            }
            out.print(json);
            out.close();
            return;
        }
        
        // If this is not an update, create a game and forward request to the Game's JSP
        gameManager.createGame(sessionId);
        request.getRequestDispatcher("/TicTacToe.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String sessionId = request.getSession().getId();
        TicTacToeGameManager gameManager = (TicTacToeGameManager) getServletContext().getAttribute("TicTacToeGameManager");

        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        JSONObject json = new JSONObject();

        if (request.getParameter("reset") != null)
        {
            if (gameManager.resetGame(sessionId))
            {
                json.put("response", "OK");
            }
            else
            {
                json.put("response", "UNSUCCESFUL");
            }
            out.print(json);
            out.close();
            return;
        }

        gameManager.makeMove(sessionId, request.getParameter("cell"));
        json.put("response", "OK");
        out.print(json);
        out.close();
        
        /*
        AsyncContext aCtx = request.startAsync(request, response); 
        ServletContext appScope = request.getServletContext(); 
        Queue<TicTacToeGame> aucBids = (Queue<TicTacToeGame>)appScope.getAttribute("TicTacToeGames");
        aucBids.add(gameManager.getGame(sessionId));
        */
    }
}
