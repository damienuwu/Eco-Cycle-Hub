<%@ page import="user.Session" %>
<%@ page import="collectionRecord.CollectionRecord" %>
<%@ page import="java.sql.*, java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    List<CollectionRecord> records = new ArrayList<CollectionRecord>();
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    String errorMessage = null;

    session = request.getSession(false);
    if (session == null || !Session.isValidCustomerSession(session, response)) {
        return;
    }
    int custID = Session.getCustID(session);

    try {
        conn = DriverManager.getConnection("jdbc:derby://localhost:1527/GreenTech", "app", "app");

        String sql = "SELECT cr.collect_id, cr.collect_weight, cr.total_amount, cr.collect_date, cr.collect_time, "
                + "cr.reward_status, cr.book_id, cr.item_id, cr.staff_id, "
                + "i.item_name, b.booking_ID, c.cust_username AS customer_username "
                + "FROM COLLECTION_RECORD cr "
                + "LEFT JOIN item i ON cr.item_id = i.item_id "
                + "LEFT JOIN booking b ON cr.book_id = b.booking_ID "
                + "LEFT JOIN staff s ON cr.staff_id = s.staff_id "
                + "LEFT JOIN customer c ON b.cust_id = c.cust_id "
                + "WHERE c.cust_id = ? "
                + "ORDER BY cr.collect_id DESC";

        ps = conn.prepareStatement(sql);
        ps.setInt(1, custID);
        rs = ps.executeQuery();

        while (rs.next()) {
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
        }
    } catch (SQLException e) {
        e.printStackTrace();
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
        <link href="../css/SidebarCustomer.css" rel="stylesheet">
        <link href="../css/CollectionRecord.css" rel="stylesheet">
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.min.js"></script>
        <script src="../js/SidebarCustomer.js"></script>
        <script src="../js/Topbar.js"></script>
        <script src="https://unpkg.com/ionicons@5.5.2/dist/ionicons.js"></script>

        <style>
            .reward-status {
                padding: 3px 8px;
                border-radius: 10px;
            }
            .reward-status.pending {
                background-color: #ffc107;
                color: black;
            }
            .reward-status.success {
                background-color: #28a745;
                color: black;
            }
            .reward-status.failed {
                background-color: #dc3545;
                color: white;
            }
            .table th, .table td {
                vertical-align: middle;
            }
            .table-bordered {
                border-bottom: 1px solid #dee2e6 !important;
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
                        </div>
                        <div class="card-body">
                            <table class="table table-bordered table-striped table-sm">
                                <thead class="table-light">
                                    <tr>
                                        <th>ID</th>
                                        <th>Weight (kg)</th>
                                        <th>Total Amount (RM)</th>
                                        <th>Date</th>
                                        <th>Time</th>
                                        <th>Reward Status</th>
                                        <th>Book ID</th>
                                        <th>Item</th>
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
                                        <td class="text-center py-3"><%= record.getCollectId()%></td> <!-- Added py-3 for padding -->
                                        <td class="text-center py-3"><%= record.getCollectWeight()%></td>
                                        <td class="text-center py-3">RM <%= record.getTotalAmount()%></td>
                                        <td class="text-center py-3"><%= record.getCollectDate()%></td>
                                        <td class="text-center py-3"><%= record.getCollectTime()%></td>
                                        <td class="text-center py-3">
                                            <span class="reward-status <%= record.getRewardStatus().equalsIgnoreCase("pending") ? "pending" : record.getRewardStatus().equalsIgnoreCase("success") ? "success" : "failed"%>">
                                                <%= record.getRewardStatus()%>
                                            </span>
                                        </td>
                                        <td class="text-center py-3"><%= record.getBookId()%></td>
                                        <td class="text-center py-3"><%= record.getItemName()%></td>
                                    </tr>
                                    <% }
                                        }%>
                                </tbody>

                            </table>
                        </div>
                    </div>
                </div>
            </main>
        </div>
    </body>
</html>