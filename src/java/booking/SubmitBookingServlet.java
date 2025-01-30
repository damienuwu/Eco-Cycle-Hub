package booking;

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;
import javax.servlet.annotation.MultipartConfig;
import java.nio.file.Paths;
import user.Session;

@MultipartConfig
public class SubmitBookingServlet extends HttpServlet {

    private BookingDAO bookingDAO;

    @Override
    public void init() throws ServletException {
        bookingDAO = new BookingDAO();
    }

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
            String uploadPath = "C:\\Users\\user\\Documents\\NetBeansProjects\\Eco-Cycle-Hub\\web\\payment";

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

        Booking booking = new Booking();
        booking.setVehicleType(vehicleType);
        booking.setPickupTime(pickupTime);
        booking.setDepositReceipt(depositReceipt);
        booking.setDepositStatus("Pending");
        booking.setBookStatus("Pending");
        booking.setCustId(custID);
        booking.setAddressId(addressID);
        
        try {
            bookingDAO.createBooking(booking);
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write("{\"status\": \"success\", \"message\": \"Booking successfully created.\", \"redirectUrl\": \"DashboardCustomer.jsp\"}");
        } catch (SQLException e) {
            e.printStackTrace();
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write("{\"status\": \"error\", \"message\": \"Database error: " + e.getMessage() + "\", \"details\": \"" + e.toString() + "\"}");
        }
    }
}
