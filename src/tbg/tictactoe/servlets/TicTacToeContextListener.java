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
    }

    @Override
    public void contextDestroyed(ServletContextEvent arg0) {
        // TODO Auto-generated method stub
    }
}
