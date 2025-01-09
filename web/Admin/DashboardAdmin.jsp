<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@ page import="java.sql.*" %>
<%@ page import="javax.servlet.http.HttpSession" %>
<%@ page import="user.Session" %>
<%@ page import="javax.servlet.http.HttpServletResponse" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    session = request.getSession(false);
    if (session == null || !Session.isValidStaffSession(session, response)) {
        return;
    }
    int staffID = Session.getStaffID(session);

    Connection connection = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    List<Map<String, String>> recentBookings = new ArrayList<Map<String, String>>();
    List<Map<String, String>> customers = new ArrayList<Map<String, String>>();  // List to hold customer data

    double totalAmount = 0;
    int rewards = 0;

    try {
        // Connect to the database
        connection = DriverManager.getConnection("jdbc:derby://localhost:1527/GreenTech", "app", "app");

        // Fetch rewards and total amount for bookings
        String query = "SELECT "
                + "SUM(c.TOTAL_AMOUNT) AS total_amount, "
                + "COUNT(c.book_ID) AS rewards, "
                + "b.booking_ID, b.pickup_date, b.pickup_time, b.book_status "
                + "FROM collection_record c "
                + "JOIN Booking b ON c.book_ID = b.booking_ID "
                + "GROUP BY b.booking_ID, b.pickup_date, b.pickup_time, b.book_status "
                + "ORDER BY b.pickup_date DESC, b.pickup_time DESC FETCH FIRST 5 ROWS ONLY";

        pstmt = connection.prepareStatement(query);
        rs = pstmt.executeQuery();
        while (rs.next()) {
            // Fetch totalAmount and rewards only once
            if (totalAmount == 0 && rewards == 0) {
                totalAmount = rs.getDouble("total_amount");
                rewards = rs.getInt("rewards");
            }

            // Fetch booking details
            Map<String, String> booking = new HashMap<String, String>();
            booking.put("booking_ID", rs.getString("booking_ID"));
            booking.put("pickup_date", rs.getString("pickup_date"));
            booking.put("pickup_time", rs.getString("pickup_time"));
            booking.put("book_status", rs.getString("book_status"));
            recentBookings.add(booking);
        }

        // Fetch customer details
        String customerQuery = "SELECT cust_ID, cust_Username, profile_picture FROM Customer ORDER BY cust_Username FETCH FIRST 5 ROWS ONLY";
        pstmt = connection.prepareStatement(customerQuery);
        rs = pstmt.executeQuery();
        while (rs.next()) {
            // Fetch customer details
            Map<String, String> customer = new HashMap<String, String>();
            customer.put("cust_ID", rs.getString("cust_ID"));
            customer.put("cust_Username", rs.getString("cust_Username"));
            customer.put("profile_picture", rs.getString("profile_picture"));
            customers.add(customer);
        }

    } catch (SQLException e) {
        e.printStackTrace();
    } finally {
        // Close resources
        if (rs != null) {
            try {
                rs.close();
            } catch (SQLException ignore) {
            }
        }
        if (pstmt != null) {
            try {
                pstmt.close();
            } catch (SQLException ignore) {
            }
        }
        if (connection != null) {
            try {
                connection.close();
            } catch (SQLException ignore) {
            }
        }
    }
%>


<!DOCTYPE html>
<html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>EcoCycleHub | Dashboard</title>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://unpkg.com/boxicons@2.0.7/css/boxicons.min.css" rel="stylesheet" />
        <link rel="stylesheet" href="../css/SidebarCustomer.css">
        <link rel="stylesheet" href="../css/DashboardAdmin.css">

        <script type="module" src="https://unpkg.com/ionicons@5.5.2/dist/ionicons/ionicons.esm.js"></script>
        <script nomodule src="https://unpkg.com/ionicons@5.5.2/dist/ionicons/ionicons.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.min.js"></script>
        <script src="../js/SidebarAdmin.js"></script>
        <script src="../js/Topbar.js"></script>
    </head>

    <body>
        <div class="container-fluid d-flex p-0">
            <div id="sidebar"></div>
            <main class="main flex-grow-1 p-4">
                <div id="topbar"></div>

                <!-- Dashboard Cards -->
                <div class="cardBox d-flex flex-wrap mb-4">
                    <div class="card p-3 text-center mb-4 col-12 col-md-6 col-lg-4">
                        <div>
                            <div class="numbers display-6"><%= rewards%></div>                            
                            <div class="cardName text-muted">Waste Collected</div>
                        </div>
                        <div class="iconBx">
                            <ion-icon name="cart-outline"></ion-icon>
                        </div>
                    </div>

                    <div class="card p-3 text-center mb-4 col-12 col-md-6 col-lg-4">
                        <div>
                            <div class="numbers display-6">RM<%= String.format("%.2f", totalAmount)%></div>
                            <div class="cardName text-muted">Earnings</div>
                        </div>
                        <div class="iconBx">
                            <ion-icon name="cash-outline"></ion-icon>
                        </div>
                    </div>
                </div>

                <!-- Details Section -->
                <div class="details">
                    <div class="row mb-4">
                        <!-- Recent Bookings Section -->
                        <div class="col-md-8 mb-4">
                            <div class="recentOrders mb-0">
                                <div class="d-flex justify-content-between align-items-center">
                                    <h2>Recent Bookings</h2>
                                    <a href="VehicleBooking.jsp" class="btn btn-primary">View All</a>
                                </div>
                                <table class="table table-striped">
                                    <thead>
                                        <tr>
                                            <th>Book ID</th>
                                            <th>Pickup Date</th>
                                            <th>Pickup Time</th>
                                            <th>Book Status</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <%
                                            for (Map<String, String> booking : recentBookings) {
                                        %>
                                        <tr>
                                            <td><%= booking.get("booking_ID")%></td>
                                            <td><%= booking.get("pickup_date")%></td>
                                            <td><%= booking.get("pickup_time")%></td>
                                            <td><%= booking.get("book_status")%></td>
                                        </tr>
                                        <%
                                            }
                                        %>
                                    </tbody>
                                </table>
                            </div>
                        </div>

                        <!-- Recent Customers Section -->
                        <div class="col-md-8 mb-4">
                            <div class="recentCustomers">
                                <h2>Recent Customers</h2>
                                <table class="table table-striped">
                                    <tbody>
                                        <%
                                            // Loop through the customers list and display each customer
                                            for (Map<String, String> customer : customers) {
                                                String custUsername = customer.get("cust_Username");
                                                String profilePic = customer.get("profile_picture");
                                                // Assuming you have customer images saved and associated with customer_id
                                                String imagePath = profilePic;
                                                System.out.println(imagePath);// You can adjust this if you have a different way of storing images.
                                        %>
                                        <tr>
                                            <td width="60">
                                                <div class="imgBx">
                                                    <%
                                                        if (imagePath == null || imagePath.isEmpty()) {
                                                            imagePath = "../uploads/default.png";  // Set to default image path if no profile image
                                                        } else {
                                                            imagePath = ".." + imagePath;  // Adjust image path if profile picture exists
                                                        }
                                                    %>
                                                    <img src="<%= imagePath%>" alt="Customer Image">
                                                </div>
                                            </td>
                                            <td>
                                                <h5><%= custUsername%> <br></h5>
                                            </td>
                                        </tr>
                                        <%
                                            }
                                        %>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </main>
        </div>
    </body>
</html>
