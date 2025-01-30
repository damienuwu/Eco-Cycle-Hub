<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page session="true" %>
<%
    // Check if the user has clicked the "Sign Out" link and invalidate the session
    String action = request.getParameter("action");
    if ("logout".equals(action)) {
        // Invalidate the session to log out the user
        session.invalidate();
        // Redirect after session invalidation
        response.sendRedirect("../index.html");
        return; // Stop further processing
    }
%>

<div id="sidebar-content" class="navigation flex-column p-3">
    <ul class="list-unstyled">
        <li class="comp-name mb-4">
            <a href="#" class="text-decoration-none text-white d-flex align-items-center">
                <span class="icon me-2">
                    <img src="../images/logo-company.png" class="sidebar-logo" />
                </span>
                <span class="title fw-bold fs-4">EcoCycleHub</span>
            </a>
        </li>
        <li class="active mb-2">
            <a href="DashboardAdmin.jsp" class="text-decoration-none text-white d-flex align-items-center">
                <span class="icon me-2"><i class='bx bx-history'></i></span>
                <span class="title">Dashboard</span>
            </a>
        </li>
        <li class="mb-2">
            <a href="../Admin/items" class="text-decoration-none text-white d-flex align-items-center">
                <span class="icon me-2"><i class='bx bxl-spring-boot'></i></span>
                <span class="title">Items</span>
            </a>
        </li>
        <li class="mb-2">
            <a href="VehicleBooking.jsp" class="text-decoration-none text-white d-flex align-items-center">
                <span class="icon me-2"><i class='bx bxs-truck' ></i></span>
                <span class="title">Vehicle Booking</span>
            </a>
        </li>
        <li class="mb-2">
            <a href="CollectionRecords.jsp" class="text-decoration-none text-white d-flex align-items-center">
                <span class="icon me-2"><i class='bx bx-user-circle'></i></span>
                <span class="title">Collection Records</span>
            </a>
        </li>
        <li class="mb-2">
            <a href="ProfileAdmin.jsp" class="text-decoration-none text-white d-flex align-items-center">
                <span class="icon me-2"><i class='bx bx-user-circle'></i></span>
                <span class="title">Profile</span>
            </a>
        </li>
        <li class="sign-out mt-auto"
            <!-- Add the action parameter to trigger logout logic -->
            <a href="SidebarAdmin.jsp?action=logout" class="text-decoration-none text-white d-flex align-items-center">
                <span class="icon me-2"><i class='bx bx-exit'></i></span>
                <span class="title">Sign Out</span>
            </a>
        </li>
    </ul>
</div>
