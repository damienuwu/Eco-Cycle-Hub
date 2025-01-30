package address;

import java.sql.*;

public class AddressDAO {
    private final String dbURL = "jdbc:derby://localhost:1527/GreenTech";
    private final String dbUser = "app";
    private final String dbPassword = "app";

    // Get Address by addressId
    public Address getAddressById(int addressId) throws SQLException {
        String sql = "SELECT * FROM Address WHERE address_id = ?";
        
        try (Connection conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, addressId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return extractAddressFromResultSet(rs);
                }
            }
        }
        return null;
    }

    // Get Address by customer ID
    public Address getAddressByCustomerId(int custId) throws SQLException {
        String sql = "SELECT * FROM Address WHERE cust_ID = ?";
        
        try (Connection conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, custId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return extractAddressFromResultSet(rs);
                }
            }
        }
        return null;
    }

    // Helper method to extract Address from ResultSet
    private Address extractAddressFromResultSet(ResultSet rs) throws SQLException {
        return new Address(
            rs.getInt("address_id"),
            rs.getString("house_no"),
            rs.getString("street_name"),
            rs.getString("city"),
            rs.getString("postcode"),
            rs.getString("state"),
            rs.getString("profile_picture"),
            rs.getInt("cust_ID")
        );
    }
}