package admin;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class UpdateRewardStatusServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get the collection ID and reward status from the request
        String collectIdParam = request.getParameter("collectId");
        String rewardStatus = request.getParameter("rewardStatus");

        // Check for required parameters
        if (collectIdParam != null && rewardStatus != null) {
            try {
                int collectId = Integer.parseInt(collectIdParam);

                // Database connection and update logic
                try (Connection conn = DriverManager.getConnection("jdbc:derby://localhost:1527/GreenTech", "app", "app")) {
                    String sql = "UPDATE COLLECTION_RECORD SET reward_status = ? WHERE collect_id = ?";
                    try (PreparedStatement ps = conn.prepareStatement(sql)) {
                        ps.setString(1, rewardStatus);
                        ps.setInt(2, collectId);

                        int rowsAffected = ps.executeUpdate();
                        response.setContentType("application/json");
                        response.setCharacterEncoding("UTF-8");

                        if (rowsAffected > 0) {
                            // Return the success status and redirect URL
                            response.getWriter().write("{\"status\": \"success\", \"message\": \"Reward status updated successfully.\", \"redirectUrl\": \"CollectionRecords.jsp\"}");
                        } else {
                            response.getWriter().write("{\"status\": \"error\", \"message\": \"Failed to update the reward status.\"}");
                        }
                    }
                } catch (SQLException e) {
                    response.setContentType("application/json");
                    response.getWriter().write("{\"status\": \"error\", \"message\": \"SQL Error: " + e.getMessage() + "\"}");
                    e.printStackTrace(); // Optional: log error to server logs
                }
            } catch (NumberFormatException e) {
                response.setContentType("application/json");
                response.getWriter().write("{\"status\": \"error\", \"message\": \"Invalid collection ID format.\"}");
                e.printStackTrace(); // Optional: log error to server logs
            }
        } else {
            // If parameters are missing, return an error
            response.setContentType("application/json");
            response.getWriter().write("{\"status\": \"error\", \"message\": \"Collection ID and reward status are required.\"}");
        }
    }
}
