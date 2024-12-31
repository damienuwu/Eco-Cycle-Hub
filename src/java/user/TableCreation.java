package user;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class TableCreation {

    public static void main(String[] args) {
        String dbUrl = "jdbc:derby://localhost:1527/GreenTech;create=true";
        String dbUser = "app";
        String dbPassword = "app";

        try (Connection connection = DriverManager.getConnection(dbUrl, dbUser, dbPassword)) {
            System.out.println("Connected to the database!");

            // Check and create tables
            createTableIfNotExists(connection, "BANK_DETAILS", 
                "CREATE TABLE bank_details (" +
                "bank_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY, " +
                "bank_name VARCHAR(50), " +
                "bank_acc_no VARCHAR(30), " +
                "bank_full_name VARCHAR(50))");

            createTableIfNotExists(connection, "CUSTOMER", 
                "CREATE TABLE Customer (" +
                "cust_ID INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY, " +
                "cust_username VARCHAR(20) UNIQUE NOT NULL, " +
                "cust_password VARCHAR(128) NOT NULL, " +
                "cust_first_name VARCHAR(30), " +
                "cust_last_name VARCHAR(30), " +
                "cust_contact_no VARCHAR(30), " +
                "cust_email VARCHAR(30), " +
                "bank_id INT, " +
                "profile_picture VARCHAR(255), " +
                "FOREIGN KEY (bank_id) REFERENCES bank_details(bank_id))");

            createTableIfNotExists(connection, "STAFF", 
                "CREATE TABLE Staff (" +
                "staff_ID INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY, " +
                "staff_username VARCHAR(20) NOT NULL UNIQUE, " +
                "staff_password VARCHAR(200) NOT NULL, " +
                "staff_first_name VARCHAR(30), " +
                "staff_last_name VARCHAR(30), " +
                "staff_contact_no VARCHAR(12), " +
                "staff_email VARCHAR(30) NOT NULL, " +
                "category VARCHAR(30), " +
                "profile_picture VARCHAR(255))");

            createTableIfNotExists(connection, "ITEM", 
                "CREATE TABLE Item (" +
                "item_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY, " +
                "item_name VARCHAR(50), " +
                "item_price DECIMAL(16, 2), " +
                "item_pict VARCHAR(255))");

            createTableIfNotExists(connection, "ADDRESS", 
                "CREATE TABLE Address (" +
                "address_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY, " +
                "house_no VARCHAR(10), " +
                "street_name VARCHAR(70), " +
                "city VARCHAR(70), " +
                "postcode VARCHAR(5), " +
                "state VARCHAR(20), " +
                "profile_picture VARCHAR(255), " +
                "cust_ID INT, " +
                "FOREIGN KEY (cust_ID) REFERENCES Customer(cust_ID))");

            createTableIfNotExists(connection, "BOOKING", 
                "CREATE TABLE Booking (" +
                "booking_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY, " +
                "vehicle_type VARCHAR(12) NOT NULL, " +
                "pickup_date DATE NOT NULL, " +
                "pickup_time VARCHAR(30), " +
                "deposit_receipt VARCHAR(255), " +
                "deposit_status VARCHAR(15), " +
                "book_status VARCHAR(15), " +
                "cust_ID INT NOT NULL, " +
                "address_id INT NOT NULL, " +
                "FOREIGN KEY (cust_ID) REFERENCES Customer(cust_ID), " +
                "FOREIGN KEY (address_id) REFERENCES Address(address_id))");

            // Insert initial data into STAFF table
            insertStaffData(connection);

            // Insert initial data into ITEM table
            insertItemData(connection);

            System.out.println("All tables verified/created, and data inserted!");

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    private static void createTableIfNotExists(Connection connection, String tableName, String createTableSQL) throws SQLException {
        String query = "SELECT * FROM SYS.SYSTABLES WHERE TABLENAME = ?";
        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setString(1, tableName.toUpperCase()); // Derby stores table names in uppercase
            ResultSet rs = ps.executeQuery();
            if (!rs.next()) { // Table does not exist
                try (PreparedStatement createStmt = connection.prepareStatement(createTableSQL)) {
                    createStmt.executeUpdate();
                    System.out.println("Created table: " + tableName);
                }
            } else {
                System.out.println("Table already exists: " + tableName);
            }
        }
    }

    private static void insertStaffData(Connection connection) throws SQLException {
        String insertSQL = "INSERT INTO Staff (staff_username, staff_password, staff_first_name, staff_last_name, staff_contact_no, staff_email, category, profile_picture) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(insertSQL)) {
            ps.setString(1, "staff01");
            ps.setString(2, "123");
            ps.setString(3, "Amin");
            ps.setString(4, "Zahin");
            ps.setString(5, "0128741011");
            ps.setString(6, "amin_zahin@gmail.com");
            ps.setString(7, "Admin");
            ps.setString(8, "");
            ps.executeUpdate();
            System.out.println("Inserted initial data into STAFF table");
        }
    }

    private static void insertItemData(Connection connection) throws SQLException {
        String insertSQL = "INSERT INTO Item (item_name, item_price, item_pict) VALUES (?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(insertSQL)) {
            ps.setString(1, "Cardboard");
            ps.setBigDecimal(2, new java.math.BigDecimal("2.50"));
            ps.setString(3, "../itemImage/cardboard.png");
            ps.executeUpdate();

            ps.setString(1, "Glass Bottle");
            ps.setBigDecimal(2, new java.math.BigDecimal("1.00"));
            ps.setString(3, "../itemImage/glass bottle.png");
            ps.executeUpdate();

            ps.setString(1, "Used Oil");
            ps.setBigDecimal(2, new java.math.BigDecimal("1.50"));
            ps.setString(3, "../itemImage/usedOil.png");
            ps.executeUpdate();

            ps.setString(1, "Plastic Bottle");
            ps.setBigDecimal(2, new java.math.BigDecimal("0.50"));
            ps.setString(3, "../itemImage/plasticBot.png");
            ps.executeUpdate();

            System.out.println("Inserted initial data into ITEM table");
        }
    }
}