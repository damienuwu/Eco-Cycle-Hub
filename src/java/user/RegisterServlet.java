package user;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.SQLException;

public class RegisterServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirm-password");

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        if (!password.equals(confirmPassword)) {
            response.getWriter().write("{\"status\": \"error\", \"message\": \"Passwords do not match!\"}");
            return;
        }

        Connection connection = null;
        PreparedStatement checkStmt = null;
        PreparedStatement insertCustomerStmt = null;
        PreparedStatement insertBankStmt = null;
        PreparedStatement updateCustomerStmt = null;
        ResultSet rs = null;

        try {
            connection = DriverManager.getConnection("jdbc:derby://localhost:1527/GreenTech", "app", "app");

            // Check if username or email already exists
            String checkQuery = "SELECT * FROM Customer WHERE cust_username = ? OR cust_email = ?";
            checkStmt = connection.prepareStatement(checkQuery);
            checkStmt.setString(1, username);
            checkStmt.setString(2, email);

            rs = checkStmt.executeQuery();
            if (rs.next()) {
                response.getWriter().write("{\"status\": \"error\", \"message\": \"Username or email already exists!\"}");
                return;
            }

            // Insert new user
            String insertCustomerQuery = "INSERT INTO Customer (cust_username, cust_email, cust_password) VALUES (?, ?, ?)";
            insertCustomerStmt = connection.prepareStatement(insertCustomerQuery, Statement.RETURN_GENERATED_KEYS);
            insertCustomerStmt.setString(1, username);
            insertCustomerStmt.setString(2, email);
            insertCustomerStmt.setString(3, password);

            int customerRowsInserted = insertCustomerStmt.executeUpdate();
            if (customerRowsInserted == 0) {
                response.getWriter().write("{\"status\": \"error\", \"message\": \"Registration failed. Please try again.\"}");
                return;
            }

            rs = insertCustomerStmt.getGeneratedKeys();
            int custID = 0;
            if (rs.next()) {
                custID = rs.getInt(1);
            }

            String insertBankQuery = "INSERT INTO bank_details (bank_name, bank_acc_no, bank_full_name) VALUES (?, ?, ?)";
            insertBankStmt = connection.prepareStatement(insertBankQuery, Statement.RETURN_GENERATED_KEYS);
            insertBankStmt.setString(1, "");
            insertBankStmt.setString(2, "");
            insertBankStmt.setString(3, "");

            int bankRowsInserted = insertBankStmt.executeUpdate();
            if (bankRowsInserted == 0) {
                response.getWriter().write("{\"status\": \"error\", \"message\": \"Failed to create bank details. Please try again.\"}");
                return;
            }

            rs = insertBankStmt.getGeneratedKeys();
            int bankID = 0;
            if (rs.next()) {
                bankID = rs.getInt(1);
            }

            String updateCustomerQuery = "UPDATE Customer SET bank_id = ? WHERE cust_ID = ?";
            updateCustomerStmt = connection.prepareStatement(updateCustomerQuery);
            updateCustomerStmt.setInt(1, bankID);
            updateCustomerStmt.setInt(2, custID);

            int rowsUpdated = updateCustomerStmt.executeUpdate();
            if (rowsUpdated > 0) {
                response.getWriter().write("{\"status\": \"success\", \"message\": \"Registration successful!\"}");
            } else {
                response.getWriter().write("{\"status\": \"error\", \"message\": \"Failed to link bank details. Please try again.\"}");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("{\"status\": \"error\", \"message\": \"An error occurred: " + e.getMessage() + "\"}");
        } finally {
            // Close resources
            try {
                if (rs != null) {
                    rs.close();
                }
                if (checkStmt != null) {
                    checkStmt.close();
                }
                if (insertCustomerStmt != null) {
                    insertCustomerStmt.close();
                }
                if (insertBankStmt != null) {
                    insertBankStmt.close();
                }
                if (updateCustomerStmt != null) {
                    updateCustomerStmt.close();
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