<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<%
    // Determine user type (Customer or Staff)
    String username = (String) session.getAttribute("cust_username");
    String staffUsername = (String) session.getAttribute("staff_username");
    String profilePicPath = "";
    String userType = ""; // To store whether the user is a customer or staff

    try {
        Connection conn = DriverManager.getConnection("jdbc:derby://localhost:1527/GreenTech", "app", "app");

        // Query and retrieve user details based on user type
        if (username != null) {
            // User is a customer
            userType = "Customer";
            String customerQuery = "SELECT * FROM Customer WHERE cust_username = ?";
            PreparedStatement ps = conn.prepareStatement(customerQuery);
            ps.setString(1, username);
            ResultSet customer = ps.executeQuery();
            if (customer.next()) {
                profilePicPath = customer.getString("profile_picture");
            }
            ps.close();
        } else if (staffUsername != null) {
            // User is a staff member
            userType = "Staff";
            String staffQuery = "SELECT * FROM Staff WHERE staff_username = ?";
            PreparedStatement ps = conn.prepareStatement(staffQuery);
            ps.setString(1, staffUsername);
            ResultSet staff = ps.executeQuery();
            if (staff.next()) {
                profilePicPath = staff.getString("profile_picture");
            }
            ps.close();
        } else {
            // No user is logged in
            response.sendRedirect("login.html"); // Redirect to login page
            return;
        }

        conn.close();
    } catch (Exception e) {
        e.printStackTrace();
    }
%>

<!DOCTYPE html>
<head>
    
</head>
<div class="d-flex justify-content-between align-items-center bg-white p-3 rounded shadow-sm mb-3">
    <div class="toggle">
        <ion-icon name="menu-outline" class="fs-4"></ion-icon>
    </div>
<!--    <div class="search w-50">
        <div class="input-group">
            <input type="text" class="form-control" placeholder="Search here">
            <button class="btn btn-outline-secondary" type="button">
                <ion-icon name="search-outline"></ion-icon>
            </button>
        </div>
    </div>-->
    <div class="user">
        <img src="<%= (profilePicPath != null && profilePicPath.length() > 1) ? "../" + profilePicPath.substring(1) : "../uploads/default.png"%>" alt="Profile Picture" class="rounded-circle" style="width: 40px; height: 40px;">
    </div>
</div>
