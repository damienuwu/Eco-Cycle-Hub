<%@ page import="user.Session" %>
<%@ page import="admin.CollectionRecord" %>
<%@ page import="java.sql.*, java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    List<CollectionRecord> records = new ArrayList<CollectionRecord>();
    Map<Integer, String> items = new HashMap<Integer, String>();
    List<String> books = new ArrayList<String>();
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    int staffId = -1; // Initialize staffId

    // Get staffId from session if available
    session = request.getSession(false);
    if (session == null || !Session.isValidStaffSession(session, response)) {
        return;
    }
    staffId = Session.getStaffID(session);

    try {
        conn = DriverManager.getConnection("jdbc:derby://localhost:1527/GreenTech", "app", "app");

        // Get the items
        String sql = "SELECT cr.collect_id, cr.collect_weight, cr.total_amount, cr.collect_date, cr.collect_time, "
                + "cr.reward_status, cr.book_id, cr.item_id, cr.staff_id, "
                + "i.item_name, b.booking_ID, s.staff_username "
                + "FROM COLLECTION_RECORD cr "
                + "LEFT JOIN item i ON cr.item_id = i.item_id "
                + "LEFT JOIN booking b ON cr.book_id = b.booking_ID "
                + "LEFT JOIN staff s ON cr.staff_id = s.staff_id "
                + "ORDER BY CR.COLLECT_ID DESC ";
        ps = conn.prepareStatement(sql);
        rs = ps.executeQuery();

        while (rs.next()) {
            // Populate the collection records
            CollectionRecord record = new CollectionRecord(
                    rs.getInt("collect_id"),
                    rs.getBigDecimal("collect_weight"),
                    rs.getBigDecimal("total_amount"),
                    rs.getDate("collect_date"),
                    rs.getString("collect_time"),
                    rs.getString("reward_status"),
                    rs.getInt("book_id"),
                    rs.getInt("item_id"),
                    rs.getInt("staff_id"),
                    rs.getString("item_name"),
                    rs.getString("staff_username")
            );
            records.add(record);
            int itemId = rs.getInt("item_id");
            String itemName = rs.getString("item_name");
            if (itemId > 0 && itemName != null && !items.containsKey(itemId)) {
                items.put(itemId, itemName);
            }

            // Populate the books list
            String bookId = rs.getString("booking_ID");
            if (bookId != null && !books.contains(bookId)) {
                books.add(bookId);
            }
        }
    } catch (SQLException e) {
        out.println("<div class='alert alert-danger'>Error: " + e.getMessage() + "</div>");
    } finally {
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
        <link rel="stylesheet" href="../css/items-1.css">

        <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.min.js"></script>
        <script type="module" src="https://unpkg.com/ionicons@5.5.2/dist/ionicons/ionicons.esm.js"></script>
        <script nomodule src="https://unpkg.com/ionicons@5.5.2/dist/ionicons/ionicons.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
        <script src="../js/SidebarAdmin.js"></script>
        <script src="../js/Topbar.js"></script>
        <style>
            .reward-status .pending {
                background-color: yellow;
                color: black;
            }

            .reward-status .success {
                background-color: green;
                color: white;
            }
            
            .reward-status {
                padding: 3px 8px;
                border-radius: 10px;
            }
        </style>
    </head>
    <body>
        <div class="container-fluid d-flex p-0">
            <div id="sidebar"></div>
            <main class="main flex-grow-1 p-4">
                <div id="topbar"></div>
                <div class="details mt-4">
                    <div class="itemlist">
                        <div class="tableHeader d-flex justify-content-between align-items-center">
                            <h2>Collection Records</h2>
                            <button class="btn btn-success" onclick="openAddModal()">Add Record</button>
                        </div>
                        <table class="table table-hover table-bordered">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Weight (kg)</th>
                                    <th>Total Amount (RM)</th>
                                    <th>Date</th>
                                    <th>Time</th>
                                    <th>Reward Status</th>
                                    <th>Book ID</th>
                                    <th>Item</th>
                                    <th>Staff</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% if (records.isEmpty()) { %>
                                <tr><td colspan="10" class="text-center">No records available.</td></tr>
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
                                    <td><%= record.getStaffName()%></td>
                                    <td><%= record.getItemName()%></td>
                                    <td>
                                        <button class="btn btn-danger btn-sm" onclick="deleteRecord(<%= record.getCollectId()%>)">Delete</button>
                                    </td>
                                </tr>
                                <% }
                                    }%>
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
                                                    // Loop through the map entries (key: item_id, value: item_name)
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
                                                <% for (String book : books) {%>
                                                <option value="<%= book%>"><%= book%></option>
                                                <% }%>
                                            </select>
                                        </div>
                                        <!-- Hidden staff ID field -->
                                        <input type="hidden" name="staffId" value="<%= staffId%>">
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
