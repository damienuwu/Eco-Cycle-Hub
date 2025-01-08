package admin;

import java.io.*;
import javax.servlet.*;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.*;
import java.sql.*;
import java.nio.file.Paths;

@MultipartConfig
public class EditItemServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect("../login.html");
            return;
        }

        String itemId = request.getParameter("itemid");
        String itemName = request.getParameter("itemname");
        String itemPriceStr = request.getParameter("itemprice");
        String currentItemPict = request.getParameter("currentitempict");

        String newItemPict = currentItemPict;

        Part newItemPicturePart = request.getPart("uploadImage");

        if (newItemPicturePart != null && newItemPicturePart.getSize() > 0) {
            String fileName = Paths.get(newItemPicturePart.getSubmittedFileName()).getFileName().toString();
            String uploadPath = "C:\\Users\\user\\Documents\\NetBeansProjects\\Eco-Cycle-Hub\\web\\itemImage";
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdir();
            }

            String newFileName = System.currentTimeMillis() + "_" + fileName;
            File file = new File(uploadPath + File.separator + newFileName);
            try (InputStream fileContent = newItemPicturePart.getInputStream();
                    FileOutputStream outputStream = new FileOutputStream(file)) {
                byte[] buffer = new byte[4096];
                int bytesRead;
                while ((bytesRead = fileContent.read(buffer)) != -1) {
                    outputStream.write(buffer, 0, bytesRead);
                }
            }
            newItemPict = "../itemImage/" + newFileName;
        } else {
            newItemPict = currentItemPict;
        }

        try {
            double itemPrice = Double.parseDouble(itemPriceStr);
            updateItem(itemId, itemName, itemPrice, newItemPict);

            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write("{\"status\": \"updated\", \"redirectUrl\": \"items-1.jsp\"}");
        } catch (NumberFormatException e) {
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write("{\"status\": \"error\", \"message\": \"Invalid price format\"}");
        } catch (SQLException e) {
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write("{\"status\": \"error\", \"message\": \"Database error: " + e.getMessage() + "\"}");
        }
    }

    private void updateItem(String itemId, String itemName, double itemPrice, String itemPict) throws SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;
        try {
            conn = DriverManager.getConnection("jdbc:derby://localhost:1527/GreenTech", "app", "app");
            String sql = "UPDATE item SET item_name = ?, item_price = ?, item_pict = ? WHERE item_id = ?";
            stmt = conn.prepareStatement(sql);

            stmt.setString(1, itemName);
            stmt.setDouble(2, itemPrice);
            stmt.setString(3, itemPict);
            stmt.setInt(4, Integer.parseInt(itemId));

            stmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
            throw new SQLException("Error updating item with ID: " + itemId, e);
        } finally {
            try {
                if (stmt != null) {
                    stmt.close();
                }
                if (conn != null) {
                    conn.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    private void deleteItem(String itemId) throws SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;
        try {
            conn = DriverManager.getConnection("jdbc:derby://localhost:1527/GreenTech", "app", "app");
            String sql = "DELETE FROM item WHERE item_id = ?";
            stmt = conn.prepareStatement(sql);

            stmt.setInt(1, Integer.parseInt(itemId));

            stmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
            throw new SQLException("Error deleting item with ID: " + itemId, e);
        } finally {
            try {
                if (stmt != null) {
                    stmt.close();
                }
                if (conn != null) {
                    conn.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}