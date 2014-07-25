package tbg.tictactoe.servlets;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Queue;
import java.util.concurrent.ConcurrentLinkedQueue;
import java.util.concurrent.Executor;
import java.util.concurrent.Executors;

import javax.servlet.AsyncContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;

import org.json.simple.JSONObject;

import tbg.tictactoe.game.TicTacToeGame;
import tbg.tictactoe.game.TicTacToeGameManager;

/**
 * @author Edward Dinki
 *
 */
@WebListener
public class TicTacToeContextListener implements ServletContextListener{

    /* (non-Javadoc)
     * @see javax.servlet.ServletContextListener#contextInitialized(javax.servlet.ServletContextEvent)
     */
    @Override
    public void contextInitialized(ServletContextEvent sce) {
        System.out.println("\nCONTEXT INIT\n");

        final TicTacToeGameManager gameManager = new TicTacToeGameManager();
        sce.getServletContext().setAttribute("TicTacToeGameManager", gameManager);

        /*
        Map<TicTacToeGame, List<AsyncContext>> watchers = new HashMap<TicTacToeGame, List<AsyncContext>>();
        sce.getServletContext().setAttribute("TicTacToeWatchers", watchers);

        Queue<TicTacToeGame> games = new ConcurrentLinkedQueue<TicTacToeGame>();
        sce.getServletContext().setAttribute("TicTacToeGames", games);
        
        Executor executor = Executors.newCachedThreadPool();
        while(true)
        {        
           if(!games.isEmpty()) // There are unpublished new bid events.
           {
              TicTacToeGame game = games.poll();
                    List<AsyncContext> gameWatchers = watchers.get(game); 
                    for(final AsyncContext aCtx : gameWatchers)
                    {
                       executor.execute(new Runnable(){
                          public void run() {
                             // publish a new bid event to a watcher
                              String sessionId = (String) aCtx.getRequest().getAttribute("SessionId");
                            aCtx.getResponse().setContentType("application/json");
                            try
                            {
                                PrintWriter out;
                                out = aCtx.getResponse().getWriter();
                                JSONObject json = new JSONObject();
                                if (!gameManager.getWinningPlayer(sessionId).isEmpty())
                                {
                                    json.put("winningPlayer", gameManager.getWinningPlayerSymbol(sessionId));
                                }
                                json.putAll(gameManager.getBoard(sessionId));
                                json.put("currentTurn", gameManager.getCurrentTurnSymbol(sessionId));
                                json.put("playerSymbol", gameManager.getPlayerSymbol(sessionId));
                                out.print(json);
                                out.close();
                            } catch (IOException e)
                            {
                                // TODO Auto-generated catch block
                                e.printStackTrace();
                            }
                          };
                       });
                    }                           
           }
        }
        */
    }

    @Override
    public void contextDestroyed(ServletContextEvent arg0) {
        // TODO Auto-generated method stub
        
    }

    /*
    class boardUpdate implements Runnable
    {
        TicTacToeGame game;
        AsyncContext asyncContext;
        
        boardUpdate(TicTacToeGame game, AsyncContext asyncContext)
        {
            this.game = game;
            this.asyncContext = asyncContext;
        }

        @Override
        public void run()
        {
                if (!gameManager.getWinningPlayer(sessionId).isEmpty())
                {
                    json.put("winningPlayer", gameManager.getWinningPlayerSymbol(sessionId));
                }
                json.putAll(gameManager.getBoard(sessionId));
                json.put("currentTurn", gameManager.getCurrentTurnSymbol(sessionId));
                json.put("playerSymbol", gameManager.getPlayerSymbol(sessionId));
            
        }
        
    }
    */
}
