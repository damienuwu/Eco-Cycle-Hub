package customer;

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;
import javax.servlet.annotation.MultipartConfig;
import java.nio.file.Paths;
import user.Session;

@MultipartConfig
public class SubmitBookingServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !Session.isValidCustomerSession(session, response)) {
            return;
        }
        int custID = Session.getCustID(session);

        response.setContentType("text/html");
        String addressIdStr = request.getParameter("address_id");
        String vehicleType = request.getParameter("vehicle");
        String pickupTime = request.getParameter("pickupTime");
        int addressID;

        try {
            if (addressIdStr != null && !addressIdStr.isEmpty()) {
                addressID = Integer.parseInt(addressIdStr);
            } else {
                throw new IllegalArgumentException("Invalid address ID received.");
            }
        } catch (NumberFormatException e) {
            e.printStackTrace();
            response.getWriter().println("Invalid address ID format.");
            return;
        }

        Part filePart = request.getPart("file");
        String depositReceipt = null;
        if (filePart != null) {
            String fileName = Paths.get(filePart.getSubmittedFileName()).toString();
            String uploadPath = "C:\\Users\\user\\Documents\\NetBeansProjects\\EcoCycleHub\\web\\payment";

            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }

            File file = new File(uploadPath + File.separator + fileName);
            try (InputStream fileContent = filePart.getInputStream(); FileOutputStream outputStream = new FileOutputStream(file)) {
                byte[] buffer = new byte[4096];
                int bytesRead;
                while ((bytesRead = fileContent.read(buffer)) != -1) {
                    outputStream.write(buffer, 0, bytesRead);
                }
            }
            depositReceipt = "../payment/" + fileName;
        }

        String depositStatus = "Pending";
        String bookStatus = "Pending";

        try (Connection conn = DriverManager.getConnection("jdbc:derby://localhost:1527/GreenTech", "app", "app")) {
            String sql = "INSERT INTO Booking (vehicle_type, pickup_date, pickup_time, deposit_receipt, deposit_status, book_status, cust_ID, address_id) "
                    + "VALUES (?, CURRENT_DATE, ?, ?, ?, ?, ?, ?)";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, vehicleType);
                ps.setString(2, pickupTime);
                ps.setString(3, depositReceipt);
                ps.setString(4, depositStatus);
                ps.setString(5, bookStatus);
                ps.setInt(6, custID);
                ps.setInt(7, addressID);

                int rowsAffected = ps.executeUpdate();
                if (rowsAffected > 0) {
                    response.setContentType("application/json");
                    response.setCharacterEncoding("UTF-8");
                    response.getWriter().write("{\"status\": \"success\", \"message\": \"Booking successfully created.\", \"redirectUrl\": \"DashboardCustomer.jsp\"}");
                    return;
                } else {
                    response.setContentType("application/json");
                    response.setCharacterEncoding("UTF-8");
                    response.getWriter().write("{\"status\": \"error\", \"message\": \"An error occurred. Please try again later.\"}");
                }
            } catch (SQLException e) {
                e.printStackTrace();
                response.getWriter().write("{\"status\": \"error\", \"message\": \"Database error: " + e.getMessage() + "\", \"details\": \"" + e.toString() + "\"}");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.getWriter().write("{\"status\": \"error\", \"message\": \"Database connection error: " + e.getMessage() + "\"}");
        }
    }
}