package booking;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Date;
import java.sql.SQLException;
import user.Session;
import javax.servlet.http.HttpSession;
import java.util.List;

public class BookingServlet extends HttpServlet {

    private BookingDAO bookingDAO;

    @Override
    public void init() throws ServletException {
        bookingDAO = new BookingDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getPathInfo();

        if (action == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Action is missing");
            return;
        }

        try {
            switch (action) {
                case "/create":
                    createBooking(request, response);
                    break;
                case "/updateStatus":
                    updateBookingStatus(request, response);
                    break;
                case "/updateDeposit":
                    updateDepositStatus(request, response);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST);
                    break;
            }
        } catch (SQLException ex) {
            throw new ServletException(ex);
        }
    }

    private void createBooking(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        Booking booking = new Booking();
        booking.setVehicleType(request.getParameter("vehicleType"));
        booking.setPickupDate(Date.valueOf(request.getParameter("pickupDate")));
        booking.setPickupTime(request.getParameter("pickupTime"));
        booking.setDepositReceipt(request.getParameter("depositReceipt"));
        booking.setDepositStatus("Pending");
        booking.setBookStatus("Pending");
        booking.setCustId(Integer.parseInt(request.getParameter("custId")));
        booking.setAddressId(Integer.parseInt(request.getParameter("addressId")));

        if (bookingDAO.createBooking(booking)) {
            response.setStatus(HttpServletResponse.SC_CREATED);
            response.getWriter().write("Booking created successfully");
        } else {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    private void updateBookingStatus(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        int bookingId = Integer.parseInt(request.getParameter("bookingId"));
        String status = request.getParameter("status");

        if (bookingDAO.updateBookingStatus(bookingId, status)) {
            response.getWriter().write("Booking status updated successfully");
        } else {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    private void updateDepositStatus(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        int bookingId = Integer.parseInt(request.getParameter("bookingId"));
        String status = request.getParameter("status");

        if (bookingDAO.updateDepositStatus(bookingId, status)) {
            response.getWriter().write("Deposit status updated successfully");
        } else {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
}
