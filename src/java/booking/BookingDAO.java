package booking;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import address.Address;

public class BookingDAO {

    private final String dbURL = "jdbc:derby://localhost:1527/GreenTech";
    private final String dbUser = "app";
    private final String dbPassword = "app";

    // Create new booking
    public boolean createBooking(Booking booking) throws SQLException {
        String sql = "INSERT INTO Booking (vehicle_type, pickup_date, pickup_time, deposit_receipt, "
                + "deposit_status, book_status, cust_ID, address_id) VALUES (?, CURRENT_DATE, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, booking.getVehicleType());
            stmt.setString(2, booking.getPickupTime());
            stmt.setString(3, booking.getDepositReceipt());
            stmt.setString(4, booking.getDepositStatus());
            stmt.setString(5, booking.getBookStatus());
            stmt.setInt(6, booking.getCustId());
            stmt.setInt(7, booking.getAddressId());

            return stmt.executeUpdate() > 0;
        }
    }

    // Get booking by ID
    public Booking getBookingById(int bookingId) throws SQLException {
        String sql = "SELECT * FROM Booking WHERE booking_id = ?";

        try (Connection conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, bookingId);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return extractBookingFromResultSet(rs);
                }
            }
        }
        return null;
    }

    // Get all bookings
    public List<Booking> getAllBookings() throws SQLException {
        List<Booking> bookings = new ArrayList<>();
        String sql = "SELECT * FROM Booking ORDER BY booking_id DESC";

        try (Connection conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                bookings.add(extractBookingFromResultSet(rs));
            }
        }
        return bookings;
    }

    // Get bookings by customer ID
    public List<Booking> getBookingsByCustomerId(int custId) throws SQLException {
        List<Booking> bookings = new ArrayList<>();
        String sql = "SELECT * FROM Booking WHERE cust_ID = ?";

        try (Connection conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, custId);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    bookings.add(extractBookingFromResultSet(rs));
                }
            }
        }
        return bookings;
    }

    public String getCustUsername(int custId) throws SQLException {
        String username = null;
        String sql = "SELECT cust_username FROM Customer WHERE cust_ID = ?"; // Replace 'username' with the actual column name

        try (Connection conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, custId);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    username = rs.getString("cust_username"); // Replace 'username' with the actual column name
                }
            }
        }
        return username;
    }

    public int getAddressId(int bookingId) throws SQLException {
        String sql = "SELECT a.address_id FROM Address a "
                + "JOIN Booking b ON a.cust_ID = b.cust_ID "
                + "WHERE b.booking_id = ?";

        try (Connection conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, bookingId); // Use bookingId to fetch the associated address

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("address_id"); // Return the address_id only
                }
            }
        }
        return -1; // Return -1 if no address_id is found for the given bookingId
    }

    // Update booking status
    public boolean updateBookingStatus(int bookingId, String bookStatus) throws SQLException {
        String sql = "UPDATE Booking SET book_status = ? WHERE booking_id = ?";

        try (Connection conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, bookStatus);
            stmt.setInt(2, bookingId);

            return stmt.executeUpdate() > 0;
        }
    }

    // Update deposit status
    public boolean updateDepositStatus(int bookingId, String depositStatus) throws SQLException {
        String sql = "UPDATE Booking SET deposit_status = ? WHERE booking_id = ?";

        try (Connection conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, depositStatus);
            stmt.setInt(2, bookingId);

            return stmt.executeUpdate() > 0;
        }
    }

    // Helper method to extract booking from ResultSet
    private Booking extractBookingFromResultSet(ResultSet rs) throws SQLException {
        return new Booking(
                rs.getInt("booking_id"),
                rs.getString("vehicle_type"),
                rs.getDate("pickup_date"),
                rs.getString("pickup_time"),
                rs.getString("deposit_receipt"),
                rs.getString("deposit_status"),
                rs.getString("book_status"),
                rs.getInt("cust_ID"),
                rs.getInt("address_id")
        );
    }
}
