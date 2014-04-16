/**
 * 
 */
package tbg.tictactoe.servlets;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.simple.JSONObject;

import tbg.tictactoe.game.InvalidGameException;
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
        Integer series = (Integer) request.getSession().getAttribute("series");
        if (series == null) {
            series = 0;
            request.getSession().setAttribute("series", series);
        }
        
        // If they want a board update send it to them
        if (request.getParameter("update") != null)
        {
            response.setContentType("application/json");
            PrintWriter out = response.getWriter();
            JSONObject json = new JSONObject();
            try
            {
                if (gameManager.gameHasBeenCreated(sessionId))
                {
                    // Block for changes, update series
                    int gameSeries = gameManager.waitForChanges(sessionId, 100, series);
                    request.getSession().setAttribute("series", gameSeries);

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
            }
            catch (InvalidGameException e) 
            {
                //response.sendError(300);
            }
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
    }
}
