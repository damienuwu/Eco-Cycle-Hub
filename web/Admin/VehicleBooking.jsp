<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="user.Session" %>
<%@ page import="javax.servlet.http.HttpSession" %>
<%@ page import="javax.servlet.http.HttpServletResponse" %>

<%
    session = request.getSession(false);
    if (session == null || !Session.isValidStaffSession(session, response)) {
        return;
    }
    int staffID = Session.getStaffID(session);
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
                            <%                                Connection conn = null;
                                PreparedStatement stmt = null;
                                ResultSet rs = null;

                                try {
                                    conn = DriverManager.getConnection("jdbc:derby://localhost:1527/GreenTech", "app", "app");

                                    String sql = "SELECT * FROM booking k JOIN customer c ON k.cust_ID = c.cust_ID ORDER BY k.booking_ID DESC";
                                    stmt = conn.prepareStatement(sql, ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY); // Scrollable ResultSet
                                    rs = stmt.executeQuery();

                                    if (!rs.isBeforeFirst()) {
                                        out.println("<p>No Booking Record</p>");
                                    } else {
                            %>
                            <div class="table-responsive">

                                <%
                                    String updateStatus = request.getParameter("updateStatus");
                                    if (updateStatus != null && updateStatus.equals("true")) {
                                        String bookingID = request.getParameter("booking_ID");
                                        String depositStatus = request.getParameter("deposit_status");
                                        try {
                                            conn = DriverManager.getConnection("jdbc:derby://localhost:1527/GreenTech", "app", "app");

                                            sql = "UPDATE booking SET deposit_status = ? WHERE booking_ID = ?";
                                            stmt = conn.prepareStatement(sql, ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                                            stmt.setString(1, depositStatus);
                                            stmt.setInt(2, Integer.parseInt(bookingID));

                                            int rowsUpdated = stmt.executeUpdate();
                                            if (rowsUpdated > 0) {
                                                out.print("success");
                                            } else {
                                                out.print("Error updating deposit status.");
                                            }

                                        } catch (Exception e) {
                                            e.printStackTrace();
                                            out.print("Database error: " + e.getMessage());
                                        } finally {
                                            try {
                                                if (stmt != null) {
                                                    stmt.close();
                                                }
                                                if (conn != null) {
                                                    conn.close();
                                                }
                                            } catch (SQLException e) {
                                                e.printStackTrace();
                                            }
                                        }
                                        return;
                                    }

                                    String bookingStatus = request.getParameter("bookingStatus");
                                    if (bookingStatus != null && bookingStatus.equals("true")) {
                                        String bookingID = request.getParameter("booking_ID");
                                        String bookStatus = request.getParameter("book_status");

                                        try {
                                            conn = DriverManager.getConnection("jdbc:derby://localhost:1527/GreenTech", "app", "app");

                                            sql = "UPDATE booking SET book_status = ? WHERE booking_ID = ?";
                                            stmt = conn.prepareStatement(sql, ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY); // Scrollable ResultSet
                                            stmt.setString(1, bookStatus);
                                            stmt.setInt(2, Integer.parseInt(bookingID));

                                            int rowsUpdated = stmt.executeUpdate();

                                            if (rowsUpdated > 0) {
                                                out.print("success");
                                            } else {
                                                out.print("error");
                                            }

                                        } catch (Exception e) {
                                            e.printStackTrace();
                                            out.print("error");
                                        } finally {
                                            try {
                                                if (stmt != null) {
                                                    stmt.close();
                                                }
                                                if (conn != null) {
                                                    conn.close();
                                                }
                                            } catch (SQLException e) {
                                                e.printStackTrace();
                                            }
                                        }
                                        return;
                                    }
                                    try {
                                        conn = DriverManager.getConnection("jdbc:derby://localhost:1527/GreenTech", "app", "app");

                                        sql = "SELECT * FROM booking k JOIN customer c ON k.cust_ID = c.cust_ID ORDER BY k.booking_ID DESC";
                                        stmt = conn.prepareStatement(sql, ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                                        rs = stmt.executeQuery();

                                        if (!rs.isBeforeFirst()) {
                                            out.println("<p>No Booking Record</p>");
                                        } else {
                                %>

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
                                        <%
                                            while (rs.next()) {
                                                String depositStatus = rs.getString("deposit_status");
                                                String bookStatus = rs.getString("book_status");
                                        %>
                                        <tr style="transition: background-color 0.3s;">
                                            <td class="text-center"><%= rs.getInt("booking_ID")%></td>
                                            <td class="text-center"><%= rs.getString("vehicle_type")%></td>
                                            <td class="text-center"><%= rs.getDate("pickup_date")%></td>
                                            <td class="text-center"><%= rs.getString("pickup_time")%></td>
                                            <td class="text-center">
                                                <%
                                                    String depositReceipt = rs.getString("deposit_receipt");
                                                    String fileExtension = depositReceipt.substring(depositReceipt.lastIndexOf(".") + 1);
                                                    if ("pdf".equalsIgnoreCase(fileExtension)) {
                                                %>
                                                <!-- PDF Button -->
                                                <a href="<%= depositReceipt%>" class="btn btn-outline-primary btn-sm" target="_blank" title="View PDF">
                                                    <i class="fa fa-file-pdf-o"></i> View PDF
                                                </a>
                                                <% }%>
                                            </td>
                                            <td class="text-center">
                                                <select id="depositStatus<%= rs.getInt("booking_ID")%>" 
                                                        class="form-select form-select-sm w-auto text-black shadow-sm status-dropdown"
                                                        onchange="toggleDepositStatus(<%= rs.getInt("booking_ID")%>, this.value)">
                                                    <option value="Approved" <%= depositStatus.equals("Approved") ? "selected" : ""%> class="success-option">Approved</option>
                                                    <option value="Pending" <%= depositStatus.equals("Pending") ? "selected" : ""%> class="pending-option">Pending</option>
                                                </select>
                                            </td>

                                            <td class="text-center">
                                                <select class="form-select form-select-sm w-auto text-black shadow-sm status-dropdown"
                                                        id="status-dropdown-<%= rs.getInt("booking_ID")%>" 
                                                        onchange="changeStatus(<%= rs.getInt("booking_ID")%>, this.value)">
                                                    <option value="Pending" <%= bookStatus.equals("Pending") ? "selected" : ""%> class="pending-option">Pending</option>
                                                    <option value="InProgress" <%= bookStatus.equals("InProgress") ? "selected" : ""%> class="inprogress-option">In Progress</option>
                                                    <option value="Success" <%= bookStatus.equals("Success") ? "selected" : ""%> class="success-option">Success</option>
                                                    <option value="Canceled" <%= bookStatus.equals("Canceled") ? "selected" : ""%> class="canceled-option">Canceled</option>
                                                </select>
                                            </td>
                                            <td class="text-center">
                                                <a href="?address_id=<%= rs.getInt("address_ID")%>" class="btn btn-primary btn-sm shadow-sm">Show</a>
                                            </td>
                                            <td class="text-center"><%= rs.getString("cust_username")%></td>
                                        </tr>
                                        <%
                                            }
                                        %>
                                    </tbody>
                                </table>
                                <%
                                        }
                                    } catch (Exception e) {
                                        e.printStackTrace();
                                        out.println("<p>Error fetching records: " + e.getMessage() + "</p>");
                                    } finally {
                                        try {
                                            if (rs != null) {
                                                rs.close();
                                            }
                                            if (stmt != null) {
                                                stmt.close();
                                            }
                                            if (conn != null) {
                                                conn.close();
                                            }
                                        } catch (SQLException e) {
                                            e.printStackTrace();
                                        }
                                    }
                                %>
                            </div>
                            <%
                                    }
                                } catch (Exception e) {
                                    out.println("<p>Error fetching records: " + e.getMessage() + "</p>");
                                    e.printStackTrace();
                                } finally {
                                    try {
                                        if (rs != null) {
                                            rs.close();
                                        }
                                        if (stmt != null) {
                                            stmt.close();
                                        }
                                        if (conn != null) {
                                            conn.close();
                                        }
                                    } catch (SQLException e) {
                                        e.printStackTrace();
                                    }
                                }
                            %>
                        </div>
                    </div>

                    <!-- Address Details -->
                    <%
                        String addressId = request.getParameter("address_id");
                        if (addressId
                                != null) {
                            try {
                                conn = DriverManager.getConnection("jdbc:derby://localhost:1527/GreenTech", "app", "app");
                                String addressSql = "SELECT * FROM address WHERE address_ID = ?";
                                stmt = conn.prepareStatement(addressSql);
                                stmt.setInt(1, Integer.parseInt(addressId));
                                rs = stmt.executeQuery();

                                if (rs.next()) {
                                    String fullAddress = rs.getString("house_no") + ", " + rs.getString("street_name") + ", "
                                            + rs.getString("city") + ", " + rs.getString("state") + " " + rs.getString("postcode");
                    %>
                    <div class="modal fade show" id="addressModal" tabindex="-1" aria-labelledby="addressModalLabel" aria-hidden="true" style="display: block;">
                        <div class="modal-dialog modal-dialog-centered">
                            <div class="modal-content shadow">
                                <div class="modal-header" style="background-color: #A8D5BA; color: #2F4F4F;">
                                    <h5 class="modal-title text-center" id="addressModalLabel">Address Details</h5>
                                </div>
                                <div class="modal-body">
                                    <p class="fs-5 text-muted"><i class="bi bi-geo-alt-fill text-primary"></i> <%= fullAddress%></p>
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-secondary" onclick="closePopup()">Close</button>
                                </div>
                            </div>
                        </div>
                    </div>
                    <%
                                }
                            } catch (Exception e) {
                                out.println("<p>Error fetching address details: " + e.getMessage() + "</p>");
                                e.printStackTrace();
                            } finally {
                                try {
                                    if (rs != null) {
                                        rs.close();
                                    }
                                    if (stmt != null) {
                                        stmt.close();
                                    }
                                    if (conn != null) {
                                        conn.close();
                                    }
                                } catch (SQLException e) {
                                    e.printStackTrace();
                                }
                            }
                        }
                    %>
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
                if (xhr.status !== 200) {
                    console.error("Failed to update the status. Please check your setup.");
                }
            };
        }

        function updateDropdownColor(selectElement, bookingID) {
            const selectedValue = selectElement.value;

            if (selectedValue === "Approved") {
                selectElement.style.backgroundColor = "#28a745";
                selectElement.style.color = "white";
            } else if (selectedValue === "Pending") {
                selectElement.style.backgroundColor = "#ffc107"; 
                selectElement.style.color = "black";            
            }

            toggleDepositStatus(bookingID, selectedValue);
        }

        document.addEventListener("DOMContentLoaded", function () {
            const dropdowns = document.querySelectorAll(".form-select");
            dropdowns.forEach((dropdown) => {
                const selectedValue = dropdown.value;
                if (selectedValue === "Approved") {
                    dropdown.style.backgroundColor = "#28a745";
                    dropdown.style.color = "white";
                } else if (selectedValue === "Pending") {
                    dropdown.style.backgroundColor = "#ffc107";
                    dropdown.style.color = "black";
                }
            });
        });
    </script>

    <script type="text/javascript">
        function changeStatus(bookingID, newStatus) {
            var xhr = new XMLHttpRequest();

            var url = "VehicleBooking.jsp";

            var params = "bookingStatus=true&booking_ID=" + bookingID + "&book_status=" + newStatus;

            xhr.open("POST", url, true);

            xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");

            xhr.onreadystatechange = function () {
                if (xhr.readyState == 4 && xhr.status == 200) {
                    var response = xhr.responseText;
                    if (response === "success") {
                        alert("Booking status updated successfully!");

                        updateDropdownColor(bookingID, newStatus);
                    }
                }
            };

            xhr.send(params);
        }

        function updateDropdownColor(bookingID, selectedValue) {
            var dropdown = document.getElementById("status-dropdown-" + bookingID);

            var options = dropdown.querySelectorAll('option');
            options.forEach(function (option) {
                if (option.value === 'Pending') {
                    option.style.backgroundColor = '#FFEB3B';
                    option.style.color = '#333';
                } else if (option.value === 'InProgress') {
                    option.style.backgroundColor = '#2196F3';
                    option.style.color = 'white';
                } else if (option.value === 'Success') {
                    option.style.backgroundColor = '#4CAF50';
                    option.style.color = 'white';
                } else if (option.value === 'Canceled') {
                    option.style.backgroundColor = '#F44336';
                    option.style.color = 'white';
                }
            });

            const selectedOption = dropdown.querySelector(`option[value='${selectedValue}']`);
            if (selectedOption) {
                selectedOption.style.backgroundColor = selectedValue === 'Pending' ? '#FFEB3B' :
                        selectedValue === 'InProgress' ? '#2196F3' :
                        selectedValue === 'Success' ? '#4CAF50' :
                        '#F44336'; // Red for Canceled
                selectedOption.style.color = '#fff';
            }
        }

        document.addEventListener("DOMContentLoaded", function () {
            const dropdowns = document.querySelectorAll(".form-select");
            dropdowns.forEach((dropdown) => {
                const selectedValue = dropdown.value;
                if (selectedValue === "Pending") {
                    dropdown.style.backgroundColor = "#FFEB3B";
                    dropdown.style.color = "#333";
                } else if (selectedValue === "InProgress") {
                    dropdown.style.backgroundColor = "#2196F3";
                    dropdown.style.color = "white";
                } else if (selectedValue === "Success") {
                    dropdown.style.backgroundColor = "#4CAF50";
                    dropdown.style.color = "white";
                } else if (selectedValue === "Canceled") {
                    dropdown.style.backgroundColor = "#F44336";
                    dropdown.style.color = "white";
                }
            });
        });
    </script>
</body>
</html>