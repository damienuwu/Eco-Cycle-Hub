package customer;

import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.http.*;
import user.Session;
import javax.servlet.annotation.MultipartConfig;

@MultipartConfig
public class AddAddressServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || !Session.isValidCustomerSession(session, response)) {
            return;
        }
        int custID = Session.getCustID(session);
        
        String houseNo = request.getParameter("houseNo");
        String streetName = request.getParameter("streetName");
        String state = request.getParameter("state");
        String city = request.getParameter("city");
        String postcode = request.getParameter("postcode");

        if (houseNo == null || houseNo.isEmpty()
                || streetName == null || streetName.isEmpty()
                || state == null || state.isEmpty()
                || city == null || city.isEmpty()
                || postcode == null || postcode.isEmpty()) {

            request.getSession().setAttribute("error", "All fields are required.");
            response.sendRedirect("Customer/ProfileCustomer.jsp");
            return;
        }

        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DriverManager.getConnection("jdbc:derby://localhost:1527/GreenTech", "app", "app");

            String insertAddress = "INSERT INTO address (house_no, street_name, city, postcode, state, cust_id) VALUES (?, ?, ?, ?, ?, ?)";
            ps = conn.prepareStatement(insertAddress);
            ps.setString(1, houseNo);
            ps.setString(2, streetName);
            ps.setString(3, city);
            ps.setString(4, postcode);
            ps.setString(5, state);
            ps.setInt(6, custID);

            int rowsInserted = ps.executeUpdate();

            if (rowsInserted > 0) {
                request.getSession().setAttribute("message", "Address added successfully.");
            } else {
                request.getSession().setAttribute("error", "Failed to add address.");
            }

        } catch (SQLException e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "Database error: " + e.getMessage());
        } finally {
            try {
                if (ps != null) {
                    ps.close();
                }
                if (conn != null) {
                    conn.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        response.sendRedirect("Customer/ProfileCustomer.jsp");
    }
}