<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="user.Session" %>
<%@ page import="javax.servlet.http.HttpSession" %>
<%@ page import="javax.servlet.http.HttpServletResponse" %>
<%@ page import="booking.BookingDAO" %>
<%@ page import="booking.Booking" %>
<%@ page import="address.Address" %>
<%@ page import="address.AddressDAO" %>
<%@ page import="java.util.List" %>

<%
    session = request.getSession(false);
    if (session == null || !Session.isValidStaffSession(session, response)) {
        return;
    }
    int staffID = Session.getStaffID(session);
%>
<%
    if ("true".equals(request.getParameter("updateStatus"))) {
        int bookingId = Integer.parseInt(request.getParameter("booking_ID"));
        String depositStatus = request.getParameter("deposit_status");

        try {
            BookingDAO bookingDAO = new BookingDAO();
            boolean success = bookingDAO.updateDepositStatus(bookingId, depositStatus);

            if (success) {
                out.print("success");
            } else {
                out.print("failure");
            }
        } catch (Exception e) {
            e.printStackTrace();
            out.print("error");
        }
        return;
    }
%>
<%
    if ("true".equals(request.getParameter("updateBookStatus"))) {
        int bookingId = Integer.parseInt(request.getParameter("booking_ID"));
        String bookStatus = request.getParameter("book_status");

        try {
            BookingDAO bookingDAO = new BookingDAO();
            boolean success = bookingDAO.updateBookingStatus(bookingId, bookStatus);

            if (success) {
                out.print("success");
            } else {
                out.print("failure");
            }
        } catch (Exception e) {
            e.printStackTrace();
            out.print("error");
        }
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>EcoCycleHub | Vehicle Booking</title>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://unpkg.com/boxicons@2.0.7/css/boxicons.min.css" rel="stylesheet" />
        <link rel="stylesheet" href="../css/SidebarCustomer.css">
        <link rel="stylesheet" href="../css/VehicleBooking.css">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">

        <script type="module" src="https://unpkg.com/ionicons@5.5.2/dist/ionicons/ionicons.esm.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/js/bootstrap.bundle.min.js"></script>
        <script src="../js/SidebarAdmin.js"></script>
        <script src="../js/Topbar.js"></script>
    </head>

    <body>
        <div class="container-fluid d-flex p-0">
            <div id="sidebar"></div>
            <main class="main flex-grow-1 p-4">
                <div id="topbar"></div>

                <div class="content mt-4">
                    <div class="card">
                        <div class="card-header d-flex justify-content-between align-items-center">
                            <h2>Vehicle Booking</h2>
                            <div class="searchbar">
                                <input type="text" id="search-member" class="form-control" placeholder="Search" onkeyup="searchMember()">
                            </div>
                        </div>
                        <div class="card-body">
                            <%
                                BookingDAO bookingDAO = new BookingDAO();
                                List<Booking> bookings = bookingDAO.getAllBookings();

                                if (bookings == null || bookings.isEmpty()) {
                            %>
                            <p>No Booking Record</p>
                            <%
                            } else {
                            %>
                            <div class="table-responsive">
                                <table class="table table-striped table-hover table-bordered align-middle">
                                    <thead class="table-light text-center" style="background-color: #A8E6CF; color: #2A4D46;">
                                        <tr>
                                            <th>Booking ID</th>
                                            <th>Vehicle Type</th>
                                            <th>Booking Date</th>
                                            <th>Pickup Time</th>
                                            <th>Deposit Receipt</th>
                                            <th>Deposit Status</th>
                                            <th>Book Status</th>
                                            <th>Address</th>
                                            <th>Username</th>
                                        </tr>
                                    </thead>
                                    <tbody style="background-color: #F1F8F6;">
                                        <% for (Booking booking : bookings) {%>
                                        <tr style="transition: background-color 0.3s;">
                                            <td class="text-center"><%= booking.getBookingId()%></td>
                                            <td class="text-center"><%= booking.getVehicleType()%></td>
                                            <td class="text-center"><%= booking.getPickupDate()%></td>
                                            <td class="text-center"><%= booking.getPickupTime()%></td>
                                            <td class="text-center">
                                                <%
                                                    String depositReceipt = booking.getDepositReceipt();
                                                    if (depositReceipt != null && depositReceipt.endsWith(".pdf")) {
                                                %>
                                                <a href="<%= depositReceipt%>" class="btn btn-outline-primary btn-sm" target="_blank" title="View PDF">
                                                    <i class="fa fa-file-pdf-o"></i> View PDF
                                                </a>
                                                <% }%>
                                            </td>
                                            <td class="text-center">
                                                <select id="depositStatus<%= booking.getBookingId()%>" 
                                                        class="form-select form-select-sm w-auto text-black shadow-sm status-dropdown"
                                                        onchange="toggleDepositStatus(<%= booking.getBookingId()%>, this.value)">
                                                    <option value="Approved" <%= "Approved".equals(booking.getDepositStatus()) ? "selected" : ""%> class="success-option">Approved</option>
                                                    <option value="Pending" <%= "Pending".equals(booking.getDepositStatus()) ? "selected" : ""%> class="pending-option">Pending</option>
                                                </select>
                                            </td>

                                            <td class="text-center">
                                                <select class="form-select form-select-sm w-auto text-black shadow-sm status-dropdown"
                                                        id="status-dropdown-<%= booking.getBookingId()%>"
                                                        onchange="changeStatus(<%= booking.getBookingId()%>, this.value)">
                                                    <option value="Pending" <%= "Pending".equals(booking.getBookStatus()) ? "selected" : ""%>>Pending</option>
                                                    <option value="InProgress" <%= "InProgress".equals(booking.getBookStatus()) ? "selected" : ""%>>In Progress</option>
                                                    <option value="Success" <%= "Success".equals(booking.getBookStatus()) ? "selected" : ""%>>Success</option>
                                                    <option value="Canceled" <%= "Canceled".equals(booking.getBookStatus()) ? "selected" : ""%>>Canceled</option>
                                                </select>
                                            </td>
                                            <td class="text-center">
                                                <a href="?address_id=<%= booking.getAddressId()%>" class="btn btn-primary btn-sm shadow-sm">Show</a>
                                            </td>
                                            <td class="text-center"><%= bookingDAO.getCustUsername(booking.getCustId())%></td>
                                        </tr>
                                        <% } %>
                                    </tbody>
                                </table>
                            </div>
                            <% } %>
                        </div>
                    </div>

                    <%
                        // Create an instance of AddressDAO
                        AddressDAO addressDAO = new AddressDAO();

                        String addressIdParam = request.getParameter("address_id");
                        int addressId = -1; // Default value for when address_id is not provided

                        if (addressIdParam != null && !addressIdParam.isEmpty()) {
                            try {
                                addressId = Integer.parseInt(addressIdParam);
                            } catch (NumberFormatException e) {
                                // Log the error or handle it appropriately
                                // e.g., log.warn("Invalid address_id format: " + addressIdParam);
                            }
                        }

                        // Retrieve the Address object by addressId
                        Address address = addressDAO.getAddressById(addressId);

                        // Check if the address exists and then display it
                        if (address != null) {
                    %>
                    <!-- Modal for Address Details -->
                    <div class="modal fade show" id="addressModal" tabindex="-1" aria-labelledby="addressModalLabel" aria-hidden="true" style="display: block;">
                        <div class="modal-dialog modal-dialog-centered">
                            <div class="modal-content shadow">
                                <div class="modal-header" style="background-color: #A8D5BA; color: #2F4F4F;">
                                    <h5 class="modal-title text-center" id="addressModalLabel">Address Details</h5>
                                </div>
                                <div class="modal-body">
                                    <p class="fs-5 text-muted"><i class="bi bi-geo-alt-fill text-primary"></i> <%= address.getFullAddress()%></p>
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-secondary" onclick="closePopup()">Close</button>
                                </div>
                            </div>
                        </div>
                    </div>
                    <%}%>
                </div>
            </main>
        </div>
    </body>

    <script>
        function closePopup() {
            location.href = 'VehicleBooking.jsp';
        }

        function searchMember() {
            var input = document.getElementById("search-member");
            var filter = input.value.toLowerCase();
            var table = document.querySelector("table");
            var rows = table.getElementsByTagName("tr");

            for (var i = 1; i < rows.length; i++) {
                var cells = rows[i].getElementsByTagName("td");
                var match = false;

                for (var j = 0; j < cells.length; j++) {
                    var cell = cells[j];
                    if (cell) {
                        var text = cell.textContent || cell.innerText;
                        if (text.toLowerCase().indexOf(filter) > -1) {
                            match = true;
                        }
                    }
                }

                if (match) {
                    rows[i].style.display = "";
                } else {
                    rows[i].style.display = "none";
                }
            }
        }

        function toggleDepositStatus(bookingID, newStatus) {
            var xhr = new XMLHttpRequest();
            xhr.open("POST", "VehicleBooking.jsp", true);
            xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");

            xhr.send("updateStatus=true&booking_ID=" + bookingID + "&deposit_status=" + newStatus);
            xhr.onload = function () {
                if (xhr.status === 200) {
                    location.reload();
                } else {
                    console.error("Failed to update the status. Please check your setup.");
                }
            };
        }

        function updateDropdownOptionsColor(dropdown) {
            const colorMap = {
                'Approved': {bg: '#28a745', color: 'white'},
                'Pending': {bg: '#ffc107', color: 'black'},
                'InProgress': {bg: '#2196F3', color: 'white'},
                'Success': {bg: '#4CAF50', color: 'white'},
                'Canceled': {bg: '#F44336', color: 'white'}
            };

            // Get all options in the dropdown  
            const options = dropdown.querySelectorAll('option');

            options.forEach(option => {
                const status = option.value;
                const colorConfig = colorMap[status] || {bg: 'transparent', color: 'black'};

                // Set inline styles for each option  
                option.style.backgroundColor = colorConfig.bg;
                option.style.color = colorConfig.color;
                option.style.padding = '5px';
            });
        }

        function updateDropdownColor(dropdown) {
            const colorMap = {
                'Approved': {bg: '#28a745', color: 'white'},
                'Pending': {bg: '#ffc107', color: 'black'},
                'InProgress': {bg: '#2196F3', color: 'white'},
                'Success': {bg: '#4CAF50', color: 'white'},
                'Canceled': {bg: '#F44336', color: 'white'}
            };

            const selectedValue = dropdown.value;
            const colorConfig = colorMap[selectedValue] || {bg: 'transparent', color: 'black'};

            dropdown.style.backgroundColor = colorConfig.bg;
            dropdown.style.color = colorConfig.color;
        }

        document.addEventListener("DOMContentLoaded", function () {
            const dropdowns = document.querySelectorAll(".form-select");

            dropdowns.forEach(dropdown => {
                // Initial color update for selected dropdown  
                updateDropdownColor(dropdown);

                // Add click event to update option colors when dropdown is opened  
                dropdown.addEventListener('click', function () {
                    updateDropdownOptionsColor(this);
                });

                // Add change event to update dropdown color when selection changes  
                dropdown.addEventListener('change', function () {
                    updateDropdownColor(this);
                });
            });
        });
    </script>

    <script type="text/javascript">
        function changeStatus(bookingID, newStatus) {
            var xhr = new XMLHttpRequest();
            xhr.open("POST", "VehicleBooking.jsp", true);
            xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");

            // Send the request with the required parameters
            xhr.send("updateBookStatus=true&booking_ID=" + bookingID + "&book_status=" + newStatus);

            xhr.onload = function () {
                if (xhr.status === 200) {
                    const response = xhr.responseText.trim();
                    if (response === "success") {
                        location.reload();
                    } else {
                        console.error("Failed to update the booking status. Response: " + response);
                    }
                } else {
                    console.error("Request failed. Status: " + xhr.status);
                }
            };
        }
    </script>
</body>
</html>