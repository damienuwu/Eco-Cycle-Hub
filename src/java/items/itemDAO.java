package items;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class itemDAO {

    String dbUrl = "jdbc:derby://localhost:1527/GreenTech";
    String dbUser = "app";
    String dbPassword = "app";

    public List<item> getAllItems() {
        List<item> itemList = new ArrayList<>();
        String query = "SELECT item_id, item_name, item_price, item_pict FROM item";

        try (Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPassword)) {

            PreparedStatement ps = conn.prepareStatement(query);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                item item = new item();
                item.setItemId(rs.getInt("item_id"));
                item.setItemName(rs.getString("item_name"));
                item.setItemPrice(rs.getDouble("item_price"));
                item.setItemPict(rs.getString("item_pict"));
                itemList.add(item);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return itemList;
    }

    public void addItem(item items) throws SQLException {
        // Database connection and query execution
        try (Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPassword)) {
            String sql = "INSERT INTO item (item_name, item_price, item_pict) VALUES (?, ?, ?)";
            try (PreparedStatement statement = conn.prepareStatement(sql)) {
                statement.setString(1, items.getItemName());
                statement.setDouble(2, items.getItemPrice());
                statement.setString(3, items.getItemPict());
                statement.executeUpdate();
            }
        }
    }
    
    public void updateItem(String itemId, String itemName, double itemPrice, String itemPict) throws SQLException {
        try (Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPassword);
             PreparedStatement stmt = conn.prepareStatement(
                     "UPDATE item SET item_name = ?, item_price = ?, item_pict = ? WHERE item_id = ?")) {
            stmt.setString(1, itemName);
            stmt.setDouble(2, itemPrice);
            stmt.setString(3, itemPict);
            stmt.setInt(4, Integer.parseInt(itemId));
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
            throw new SQLException("Error updating item with ID: " + itemId, e);
        }
    }
}
