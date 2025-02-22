<%@ page import="user.Session" %>
<%@ page import="collectionRecord.CollectionRecord" %>
<%@ page import="java.sql.*, java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%

    session = request.getSession(false);
    if (session == null || !Session.isValidStaffSession(session, response)) {
        return;
    }
    int staffID = Session.getStaffID(session);
    // Maps and lists to hold data
    Map<Integer, String> items = new HashMap<Integer, String>();
    Map<String, String> books = new HashMap<String, String>();
    List<CollectionRecord> records = new ArrayList<CollectionRecord>();
    Map<Integer, String> collectionItems = new HashMap<Integer, String>();
    List<String> collectionBooks = new ArrayList<String>();

    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    String errorMessage = null;

    try {
        conn = DriverManager.getConnection("jdbc:derby://localhost:1527/GreenTech", "app", "app");

        String itemSql = "SELECT item_id, item_name FROM item ORDER BY item_name ASC";
        ps = conn.prepareStatement(itemSql);
        rs = ps.executeQuery();

        while (rs.next()) {
            int itemId = rs.getInt("item_id");
            String itemName = rs.getString("item_name");
            if (itemId > 0 && itemName != null) {
                items.put(itemId, itemName);
            }
        }
        rs.close(); // Close ResultSet after use

        // --- Retrieve bookings for form ---
        String bookingSql = "SELECT b.booking_id, c.cust_username "
                + "FROM booking b "
                + "LEFT JOIN customer c ON b.cust_id = c.cust_id "
                + "ORDER BY b.booking_id ASC";
        ps = conn.prepareStatement(bookingSql);
        rs = ps.executeQuery();

        while (rs.next()) {
            String bookingId = rs.getString("booking_id");
            String customerUsername = rs.getString("cust_username");

            if (bookingId != null && !bookingId.isEmpty()) {
                books.put(bookingId, customerUsername);
            }
        }
        rs.close();
        ps.close();

        List<Map.Entry<String, String>> sortedBooks = new ArrayList<Map.Entry<String, String>>(books.entrySet());

        Collections.sort(sortedBooks, new Comparator<Map.Entry<String, String>>() {
            public int compare(Map.Entry<String, String> entry1, Map.Entry<String, String> entry2) {
                // Compare based on booking_id (key)
                return entry1.getKey().compareTo(entry2.getKey());
            }
        });

        // --- Retrieve collection records to display table ---
        String collectionSql = "SELECT cr.collect_id, cr.collect_weight, cr.total_amount, cr.collect_date, cr.collect_time, "
                + "cr.reward_status, cr.book_id, cr.item_id, cr.staff_id, "
                + "i.item_name, b.booking_ID, c.cust_username AS customer_username " // Join customer table to fetch the customer username
                + "FROM COLLECTION_RECORD cr "
                + "LEFT JOIN item i ON cr.item_id = i.item_id "
                + "LEFT JOIN booking b ON cr.book_id = b.booking_ID "
                + "LEFT JOIN staff s ON cr.staff_id = s.staff_id "
                + "LEFT JOIN customer c ON b.cust_id = c.cust_id " // Join the customer table to fetch the customer username
                + "ORDER BY cr.collect_id DESC ";

        ps = conn.prepareStatement(collectionSql);
        rs = ps.executeQuery();

        while (rs.next()) {
            // Populate collection records for display
            CollectionRecord record = new CollectionRecord(
                    rs.getInt("collect_id"),
                    rs.getBigDecimal("collect_weight"),
                    rs.getBigDecimal("total_amount"),
                    rs.getDate("collect_date"),
                    rs.getString("collect_time"),
                    rs.getString("reward_status"),
                    rs.getInt("book_id"),
                    rs.getInt("item_id"),
                    rs.getString("item_name"),
                    rs.getString("customer_username")
            );
            records.add(record);

            // Add item to collectionItems map
            int itemId = rs.getInt("item_id");
            String itemName = rs.getString("item_name");
            if (itemId > 0 && itemName != null) {
                if (!collectionItems.containsKey(itemId)) {
                    collectionItems.put(itemId, itemName);
                }
            }

            // Add booking ID to collectionBooks list
            String bookingId = rs.getString("booking_ID");
            if (bookingId != null && !bookingId.isEmpty()) {
                if (!collectionBooks.contains(bookingId)) {
                    collectionBooks.add(bookingId);
                }
            }
        }
    } catch (SQLException e) {
        errorMessage = "An error occurred: " + e.getMessage();
    } finally {
        // Close resources in finally block to ensure they are always closed
        if (rs != null) {
            try {
                rs.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        if (ps != null) {
            try {
                ps.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        if (conn != null) {
            try {
                conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
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
        <title>EcoCycleHub | Collection Records</title>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://unpkg.com/boxicons@2.0.7/css/boxicons.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/sweetalert2@11.5.5/dist/sweetalert2.min.css" rel="stylesheet">
        <link rel="stylesheet" href="../css/SidebarCustomer.css">
        <link rel="stylesheet" href="../css/CollectionRecord.css">

        <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.min.js"></script>
        <script type="module" src="https://unpkg.com/ionicons@5.5.2/dist/ionicons/ionicons.esm.js"></script>
        <script nomodule src="https://unpkg.com/ionicons@5.5.2/dist/ionicons/ionicons.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
        <script src="../js/SidebarAdmin.js"></script>
        <script src="../js/Topbar.js"></script>

        <style>
            .table-bordered {
                border: 1px solid #dee2e6;
            }

            .table-bordered tbody tr:last-child {
                border-bottom: 1px solid #dee2e6;
            }
        </style>
    </head>
    <body>
        <div class="container-fluid d-flex p-0">
            <div id="sidebar"></div>
            <main class="main flex-grow-1 p-4">
                <% if (errorMessage != null) {%>
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <strong>Error:</strong> <%= errorMessage%>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
                <% } %>
                <div id="topbar"></div>
                <div class="details mt-4">
                    <div class="itemlist shadow-sm p-4 bg-white rounded">
                        <div class="tableHeader d-flex justify-content-between align-items-center mb-4">
                            <h2 class="section-title">Collection Records</h2>
                            <button class="btn btn-primary" onclick="openAddModal()"><i class="bx bx-plus"></i> Add Record</button>
                        </div>
                        <table class="table table-striped table-hover table-bordered">
                            <thead class="table-dark">
                                <tr>
                                    <th>ID</th>
                                    <th>Weight (kg)</th>
                                    <th>Total Amount (RM)</th>
                                    <th>Date</th>
                                    <th>Time</th>
                                    <th>Reward Status</th>
                                    <th>Book ID</th>
                                    <th>Item</th>
                                    <th>Customer</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% if (records.isEmpty()) { %>
                                <tr>
                                    <td colspan="10" class="text-center text-muted">No records available.</td>
                                </tr>
                                <% } else {
                                    for (CollectionRecord record : records) {%>
                                <tr>
                                    <td><%= record.getCollectId()%></td>
                                    <td><%= record.getCollectWeight()%></td>
                                    <td>RM <%= record.getTotalAmount()%></td>
                                    <td><%= record.getCollectDate()%></td>
                                    <td><%= record.getCollectTime()%></td>
                                    <td id="rewardStatusTd_<%= record.getCollectId()%>">
                                        <select name="rewardStatus" class="form-select form-select-sm reward-status" onchange="updateRewardStatus(<%= record.getCollectId()%>, this.value)">
                                            <option value="Pending" class="pending" <%= record.getRewardStatus().equals("Pending") ? "selected" : ""%>>Pending</option>
                                            <option value="Success" class="success" <%= record.getRewardStatus().equals("Success") ? "selected" : ""%>>Success</option>
                                        </select>
                                    </td>



                                    <td><%= record.getBookId()%></td>
                                    <td><%= record.getItemName()%></td>
                                    <td><%= record.getCustomerUsername()%></td>
                                    <td>
                                        <button class="btn btn-danger btn-sm" onclick="deleteRecord(<%= record.getCollectId()%>)"><i class="bx bx-trash"></i> Delete</button>
                                    </td>
                                </tr>
                                <% }
                                    } %>
                            </tbody>
                        </table>
                    </div>

                    <!-- Add Collection Modal -->
                    <div id="AddModal" class="modal fade" tabindex="-1" aria-labelledby="AddModalLabel" aria-hidden="true">
                        <div class="modal-dialog modal-dialog-centered">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <h5 class="modal-title" id="AddModalLabel">Add Collection Record</h5>
                                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                </div>
                                <div class="modal-body">
                                    <form id="AddForm" action="../AddCollectionServlet" method="post">
                                        <!-- Form fields for adding collection record -->
                                        <div class="mb-3">
                                            <label for="weight" class="form-label">Weight (kg)</label>
                                            <input type="number" step="0.01" class="form-control" id="weight" name="weight" required>
                                        </div>
                                        <div class="mb-3">
                                            <label for="totalAmount" class="form-label">Total Amount (RM)</label>
                                            <input type="number" step="0.01" class="form-control" id="totalAmount" name="totalAmount" required>
                                        </div>
                                        <div class="mb-3">
                                            <label for="collectDate" class="form-label">Date</label>
                                            <input type="date" class="form-control" id="collectDate" name="collectDate" required>
                                        </div>
                                        <div class="mb-3">
                                            <label for="collectTime" class="form-label">Time</label>
                                            <input type="time" class="form-control" id="collectTime" name="collectTime" required>
                                        </div>
                                        <!-- Item Dropdown -->
                                        <div class="mb-3">
                                            <label for="itemId" class="form-label">Select Item</label>
                                            <select class="form-select" id="itemId" name="itemId" required>
                                                <%
                                                    for (Map.Entry<Integer, String> entry : items.entrySet()) {
                                                %>
                                                <option value="<%= entry.getKey()%>"><%= entry.getValue()%></option>
                                                <%
                                                    }
                                                %>
                                            </select>

                                        </div>

                                        <!-- Book Dropdown -->
                                        <div class="mb-3">
                                            <label for="bookId" class="form-label">Select Booking ID</label>
                                            <select class="form-select" id="bookId" name="bookId" required>
                                                <%
                                                    for (Map.Entry<String, String> entry : books.entrySet()) {
                                                %>
                                                <option value="<%= entry.getKey()%>">
                                                    Booking Id: <%= entry.getKey()%> (Username: <%= entry.getValue()%>)
                                                </option>
                                                <%
                                                    }
                                                %>
                                            </select>
                                        </div>

                                        <!-- Hidden staff ID field -->
                                        <input type="hidden" name="staffId" value="<%= staffID%>">
                                        <div class="text-center">
                                            <button type="submit" class="btn btn-success">Add Record</button>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </div>
                    <!-- End Add Collection Modal -->
                </div>
            </main>
        </div>

        <script>
            function openAddModal() {
                new bootstrap.Modal(document.getElementById('AddModal')).show();
            }

            document.getElementById('AddForm').addEventListener('submit', function (event) {
                event.preventDefault();
                const formData = new FormData(this);
                formData.forEach((value, key) => console.log(key + ": " + value));

                fetch('../AddCollectionServlet', {
                    method: 'POST',
                    body: formData
                })
                        .then(response => response.json())
                        .then(data => {
                            if (data.status === 'success') {
                                Swal.fire({
                                    icon: 'success',
                                    title: 'Record Added!',
                                    text: 'The collection record has been successfully added.',
                                }).then(() => {
                                    location.reload();  // Reload to show updated records
                                });
                            } else {
                                alert(data.message);
                            }
                        })
                        .catch(error => console.error('Error:', error));
            });

            function deleteRecord(recordId) {
                Swal.fire({
                    title: 'Are you sure?',
                    text: 'You won\'t be able to undo this action!',
                    icon: 'warning',
                    showCancelButton: true,
                    confirmButtonText: 'Yes, delete it!',
                    cancelButtonText: 'Cancel'
                }).then((result) => {
                    if (result.isConfirmed) {
                        // Create form data to send to the servlet
                        const formData = new FormData();
                        formData.append("collectId", recordId);

                        fetch('../DeleteCollectionServlet', {
                            method: 'POST',
                            body: formData
                        })
                                .then(response => response.json())
                                .then(data => {
                                    if (data.status === 'success') {
                                        Swal.fire('Deleted!', 'The record has been deleted.', 'success')
                                                .then(() => location.reload());  // Reload to show updated records
                                    } else {
                                        Swal.fire('Error!', 'The record could not be deleted.', 'error');
                                    }
                                })
                                .catch(error => console.error('Error:', error));
                    }
                });
            }

            function updateRewardStatus(recordId, status) {
                fetch('../UpdateRewardStatusServlet', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: new URLSearchParams({
                        collectId: recordId,
                        rewardStatus: status
                    })
                })
                        .then(response => response.json())
                        .then(data => {
                            if (data.status === 'success') {
                                Swal.fire({
                                    icon: 'success',
                                    title: 'Reward Status Updated!',
                                    text: data.message
                                }).then(() => {
                                    // Redirect to the provided URL from the server response
                                    if (data.redirectUrl) {
                                        location.reload();  // Reload the page to show updated records
                                    }
                                });
                            } else {
                                Swal.fire('Error', 'Unable to update reward status.', 'error');
                            }
                        })
                        .catch(error => console.error('Error:', error));
            }


            document.querySelector('form[action="../UpdateRewardStatusServlet"]').addEventListener('submit', function (event) {
                event.preventDefault(); // Prevent traditional form submission

                const formData = new FormData(this);

                fetch('../UpdateRewardStatusServlet', {
                    method: 'POST',
                    body: formData
                })
                        .then(response => response.json())
                        .then(data => {
                            if (data.status === 'success') {
                                Swal.fire({
                                    icon: 'success',
                                    title: data.message, // Display the success message
                                    text: 'The reward status has been updated successfully.'
                                }).then(() => {
                                    // Redirect to the CollectionRecords.jsp page
                                    window.location.href = data.redirectUrl;
                                });
                            } else {
                                Swal.fire({
                                    icon: 'error',
                                    title: 'Error',
                                    text: data.message  // Show the error message if failed
                                });
                            }
                        })
                        .catch(error => {
                            console.error('Error:', error);
                            Swal.fire({
                                icon: 'error',
                                title: 'Network Error',
                                text: 'There was an issue updating the reward status.'
                            });
                        });
            });

        </script>

    </body>
</html>