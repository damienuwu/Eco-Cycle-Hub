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
                            <div class="numbers display-6">80</div>
                            <div class="cardName text-muted">Sales</div>
                        </div>
                        <div class="iconBx">
                            <ion-icon name="cart-outline"></ion-icon>
                        </div>
                    </div>

                    <div class="card p-3 text-center mb-4 col-12 col-md-6 col-lg-4">
                        <div>
                            <div class="numbers display-6">$7,842</div>
                            <div class="cardName text-muted">Earnings</div>
                        </div>
                        <div class="iconBx">
                            <ion-icon name="cash-outline"></ion-icon>
                        </div>
                    </div>
                </div>

                <!-- Details Section -->
                <div class="details">
                    <div class="recentOrders mb-4">
                        <h2>Recent Orders</h2>
                        <table class="table table-striped">
                            <thead>
                                <tr>
                                    <th>Name</th>
                                    <th>Price</th>
                                    <th>Payment</th>
                                    <th>Status</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td>Star Refrigerator</td>
                                    <td>$1200</td>
                                    <td>Paid</td>
                                    <td><span class="status delivered">Delivered</span></td>
                                </tr>
                                <tr>
                                    <td>Dell Laptop</td>
                                    <td>$110</td>
                                    <td>Pending</td>
                                    <td><span class="status pending">Pending</span></td>
                                </tr>
                                <tr>
                                    <td>Apple Watch</td>
                                    <td>$1200</td>
                                    <td>Paid</td>
                                    <td><span class="status return">Return</span></td>
                                </tr>
                            </tbody>
                        </table>
                    </div>

                    <!-- Recent Customers -->
                    <div class="recentCustomers">
                        <h2>Recent Customers</h2>
                        <table class="table table-striped">
                            <tbody>
                                <tr>
                                    <td width="60">
                                        <div class="imgBx"><img src="assets/imgs/customer02.jpg" alt=""></div>
                                    </td>
                                    <td>
                                        <h5>David <br><span>Italy</span></h5>
                                    </td>
                                </tr>
                                <tr>
                                    <td width="60">
                                        <div class="imgBx"><img src="assets/imgs/customer01.jpg" alt=""></div>
                                    </td>
                                    <td>
                                        <h5>Amit <br><span>India</span></h5>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </main>
        </div>
    </body>
</html>