<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, java.util.List" %>
<%@ page import="user.Session" %>
<%@ page import="booking.BookingDAO" %>
<%@ page import="booking.Booking" %>

<%
    session = request.getSession(false);
    if (session == null || !Session.isValidCustomerSession(session, response)) {
        return;
    }
    int customerId = Session.getCustID(session);

    BookingDAO bookingDAO = new BookingDAO();
    List<Booking> bookings = bookingDAO.getBookingsByCustomerId(customerId);
%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Booking History</title>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="../css/SidebarCustomer.css">
        <link rel="stylesheet" href="../css/VehicleBooking.css">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">
        <link href="https://unpkg.com/boxicons@2.0.7/css/boxicons.min.css" rel="stylesheet" />
        <script type="module" src="https://unpkg.com/ionicons@5.5.2/dist/ionicons/ionicons.esm.js"></script>

        <script src="../js/SidebarCustomer.js"></script>
        <script src="../js/Topbar.js"></script>
    </head>

    <body>
        <div class="container-fluid d-flex p-0">
            <div id="sidebar" class="d-none d-md-block bg-light"></div>

            <main class="main flex-grow-1 p-4">
                <div id="topbar" class="mb-4"></div>

                <div class="container">
                    <div class="card shadow-sm">
                        <div class="card-header bg-success text-white">
                            <h4 class="mb-0">Booking History</h4>
                        </div>
                        <div class="card-body">
                            <% if (bookings == null || bookings.isEmpty()) { %>
                            <p class="text-muted">No Booking Record</p>
                            <% } else { %>
                            <div class="table-responsive">
                                <table class="table table-bordered table-hover text-center align-middle">
                                    <thead class="table-success">
                                        <tr>
                                            <th>Booking ID</th>
                                            <th>Vehicle Type</th>
                                            <th>Booking Date</th>
                                            <th>Pickup Time</th>
                                            <th>Deposit Status</th>
                                            <th>Booking Status</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <% for (Booking booking : bookings) {%>
                                        <tr>
                                            <td><%= booking.getBookingId()%></td>
                                            <td><%= booking.getVehicleType()%></td>
                                            <td><%= booking.getPickupDate()%></td>
                                            <td><%= booking.getPickupTime()%></td>
                                            <td>
                                                <span class="badge 
                                                      <%= "Approved".equals(booking.getDepositStatus()) ? "bg-success" : "bg-warning text-dark"%>">
                                                    <%= booking.getDepositStatus()%>
                                                </span>
                                            </td>
                                            <td>
                                                <span class="badge 
                                                      <%= "Success".equals(booking.getBookStatus()) ? "bg-success"
                                                              : "Pending".equals(booking.getBookStatus()) ? "bg-warning text-dark"
                                                              : "InProgress".equals(booking.getBookStatus()) ? "bg-primary"
                                                              : "Canceled".equals(booking.getBookStatus()) ? "bg-danger" : "bg-secondary"%>">
                                                    <%= booking.getBookStatus()%>
                                                </span>
                                            </td>
                                        </tr>
                                        <% } %>
                                    </tbody>
                                </table>
                            </div>
                            <% }%>
                        </div>
                    </div>
                </div>
            </main>
        </div>
    </body>
</html>