<%@ page import="java.sql.*, javax.servlet.*, javax.servlet.http.*, java.io.*" %>
<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="user.Session" %>

<%
    session = request.getSession(false);
    if (session == null || !Session.isValidCustomerSession(session, response)) {
        return;
    }
    int custID = Session.getCustID(session);

    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;

    List<Map<String, Object>> items = new ArrayList<Map<String, Object>>();

    try {
        conn = DriverManager.getConnection("jdbc:derby://localhost:1527/GreenTech", "app", "app");

        String sql = "SELECT item_name, item_price, item_pict FROM item";
        stmt = conn.prepareStatement(sql);
        rs = stmt.executeQuery();

        while (rs.next()) {
            Map<String, Object> item = new HashMap<String, Object>();
            item.put("name", rs.getString("item_name"));
            item.put("price", rs.getDouble("item_price"));
            item.put("pict", rs.getString("item_pict"));
            items.add(item);
        }
    } catch (SQLException e) {
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

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>EcoCycleHub - Items</title>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://unpkg.com/boxicons@2.0.7/css/boxicons.min.css" rel="stylesheet" />
        <link rel="stylesheet" href="../css/items-customer.css">
        <link rel="stylesheet" href="../css/SidebarCustomer.css">

        <script type="module" src="https://unpkg.com/ionicons@5.5.2/dist/ionicons/ionicons.esm.js"></script>
        <script nomodule src="https://unpkg.com/ionicons@5.5.2/dist/ionicons/ionicons.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
        <script src="../js/SidebarCustomer.js"></script>
        <script src="../js/Topbar.js"></script>

    </head>
    <body>
        <div class="container-fluid d-flex p-0">
            <nav id="sidebar"></nav>

            <main class="main flex-grow-1 bg-light">
                <div id="topbar"></div>

                <div class="container-fluid py-3">
                    <div class="items-header">
                        <h2>Items</h2>
                        <p>These are the items that we accept:</p>
                    </div>
                    <div class="items-grid">
                        <%
                            for (Map<String, Object> item : items) {
                                String itemName = (String) item.get("name");
                                Double itemPrice = (Double) item.get("price");
                                String itemPict = (String) item.get("pict");
                        %>
                        <div class="item-card">
                            <img src="<%= itemPict%>" alt="<%= itemName%>">
                            <h3><%= itemName%></h3>
                            <p>RM <%= String.format("%.2f", itemPrice)%>/KG</p>
                        </div>
                        <%}%>
                    </div>
                </div>
            </main>
        </div>
    </body>
</html>