<%@ page import="items.item" %>
<%@ page import="items.itemDAO" %>
<%@ page import="java.util.List" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<jsp:useBean id="itemDAO" class="items.itemDAO"/>

<%
    List<item> itemList = itemDAO.getAllItems();
    request.setAttribute("itemList", itemList);
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
                        <c:forEach var="item" items="${itemList}">
                            <div class="item-card">
                                <img src="${item.itemPict}" alt="${item.itemName}">
                                <h3>${item.itemName}</h3>
                                <p>RM <fmt:formatNumber value="${item.itemPrice}" maxFractionDigits="2" minFractionDigits="2" /></p>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </main>
        </div>
    </body>
</html>