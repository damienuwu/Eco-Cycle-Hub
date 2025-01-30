<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page session="true" %>

<%
    String action = request.getParameter("action");
    if ("logout".equals(action)) {
        session.invalidate();
        response.sendRedirect("../index.html");
        return;
    }
%>

<div id="sidebar-content" class="navigation flex-column p-3">
    <ul class="list-unstyled">
        <li class="mb-4">
            <a href="#" class="text-decoration-none text-white d-flex align-items-center">
                <span class="icon me-2">
                    <img src="../images/logo-company.png" class="sidebar-logo" />
                </span>
                <span class="title fw-bold fs-4">EcoCycleHub</span>
            </a>
        </li>
        <li class="active mb-2">
            <a href="../Customer/DashboardCustomer.jsp" class="text-decoration-none text-white d-flex align-items-center">
                <span class="icon me-2"><i class='bx bx-history'></i></span>
                <span class="title">Dashboard</span>
            </a>
        </li>
        <li class="mb-2">
            <a href="items-customer.jsp" class="text-decoration-none text-white d-flex align-items-center">
                <span class="icon me-2"><i class='bx bxl-spring-boot'></i></span>
                <span class="title">Items</span>
            </a>
        </li>
        <li class="mb-2">
            <a href="HistoryBooking.jsp" class="text-decoration-none text-white d-flex align-items-center">
                <span class="icon me-2"><i class='bx bx-history'></i></span>
                <span class="title">History Booking</span>
            </a>
        </li>
        <li class="mb-2">
            <a href="CollectionRecords.jsp" class="text-decoration-none text-white d-flex align-items-center">
                <span class="icon me-2"><i class='bx bx-user-circle'></i></span>
                <span class="title">Collection Records</span>
            </a>
        </li>
        <li class="mb-2">
            <a href="ProfileCustomer.jsp" class="text-decoration-none text-white d-flex align-items-center">
                <span class="icon me-2"><i class='bx bx-user-circle'></i></span>
                <span class="title">Profile</span>
            </a>
        </li>
        <li class="mb-2">
            <a href="SidebarCustomer.jsp?action=logout" class="text-decoration-none text-white d-flex align-items-center">
                <span class="icon me-2"><i class='bx bx-exit'></i></span>
                <span class="title">Sign Out</span>
            </a>
        </li>
    </ul>
</div>
