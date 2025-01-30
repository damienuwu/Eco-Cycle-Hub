package collectionRecord;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.annotation.MultipartConfig;

@MultipartConfig
public class DeleteCollectionServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get the collection ID from the request
        String collectIdParam = request.getParameter("collectId");
        if (collectIdParam != null) {
            int collectId = Integer.parseInt(collectIdParam);

            // Database connection and deletion logic
            try (Connection conn = DriverManager.getConnection("jdbc:derby://localhost:1527/GreenTech", "app", "app")) {
                String sql = "DELETE FROM COLLECTION_RECORD WHERE collect_id = ?";
                try (PreparedStatement ps = conn.prepareStatement(sql)) {
                    ps.setInt(1, collectId);

                    int rowsAffected = ps.executeUpdate();
                    if (rowsAffected > 0) {
                        response.setContentType("application/json");
                        response.getWriter().write("{\"status\": \"success\", \"message\": \"Record deleted successfully.\"}");
                    } else {
                        response.setContentType("application/json");
                        response.getWriter().write("{\"status\": \"error\", \"message\": \"Failed to delete the record.\"}");
                    }
                }
            } catch (SQLException e) {
                response.setContentType("application/json");
                response.getWriter().write("{\"status\": \"error\", \"message\": \"Error: " + e.getMessage() + "\"}");
            }
        } else {
            response.setContentType("application/json");
            response.getWriter().write("{\"status\": \"error\", \"message\": \"Collection ID is required.\"}");
        }
    }
}
