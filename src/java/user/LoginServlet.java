package user;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.*;

public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet rs = null;

        try {
            connection = DriverManager.getConnection("jdbc:derby://localhost:1527/GreenTech", "app", "app");

            String customerQuery = "SELECT * FROM Customer WHERE cust_username = ? AND cust_password = ?";
            String staffQuery = "SELECT * FROM Staff WHERE staff_username = ? AND staff_password = ?";

            preparedStatement = connection.prepareStatement(customerQuery);
            preparedStatement.setString(1, username);
            preparedStatement.setString(2, password);
            rs = preparedStatement.executeQuery();

            if (rs.next()) {
                HttpSession session = request.getSession();
                session.setAttribute("cust_ID", rs.getString("cust_ID"));
                session.setAttribute("cust_username", username);

                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                response.getWriter().write("{\"status\": \"success\", \"redirectUrl\": \"Customer/DashboardCustomer.jsp\"}");
                return;
            }

            preparedStatement = connection.prepareStatement(staffQuery);
            preparedStatement.setString(1, username);
            preparedStatement.setString(2, password);
            rs = preparedStatement.executeQuery();

            if (rs.next()) {
                HttpSession session = request.getSession();
                session.setAttribute("staff_ID", rs.getString("staff_ID"));
                session.setAttribute("staff_username", username);

                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                response.getWriter().write("{\"status\": \"success\", \"redirectUrl\": \"Admin/DashboardAdmin.jsp\"}");
                return;
            }

            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write("{\"status\": \"error\", \"message\": \"Invalid username or password.\"}");

        } catch (SQLException e) {
            e.printStackTrace();
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write("{\"status\": \"error\", \"message\": \"An error occurred. Please try again later.\"}");
        } finally {
            try {
                if (rs != null) {
                    rs.close();
                }
                if (preparedStatement != null) {
                    preparedStatement.close();
                }
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}