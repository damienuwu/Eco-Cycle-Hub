package items;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

public class displayItemServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Fetch items from the DAO
        try {
            itemDAO itemDAO = new itemDAO();
            List<item> itemList = itemDAO.getAllItems();

            // Set items as a request attribute
            request.setAttribute("itemList", itemList);

            // Forward request to items-1.jsp
            RequestDispatcher dispatcher = request.getRequestDispatcher("/Admin/items-1.jsp");
            dispatcher.forward(request, response);
        } catch (Exception e) {
            // Handle error
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error fetching items");
        }
    }
}