package admin;

import java.io.*;
import javax.servlet.*;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.*;
import java.sql.*;
import java.nio.file.Paths;

@MultipartConfig
public class AddItemServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect("../login.html");
            return;
        }

        String itemName = request.getParameter("itemname");
        String itemPrice = request.getParameter("itemprice");
        Part filePart = request.getPart("itempict");

        String filePath = null;
        if (filePart != null && filePart.getSize() > 0) {
            String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();

            String uploadPath = "C:\\Users\\user\\Documents\\NetBeansProjects\\Eco-Cycle-Hub\\web\\itemImage";
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdir();
            }

            File file = new File(uploadPath + File.separator + fileName);
            try (InputStream fileContent = filePart.getInputStream(); FileOutputStream outputStream = new FileOutputStream(file)) {
                byte[] buffer = new byte[4096];
                int bytesRead;
                while ((bytesRead = fileContent.read(buffer)) != -1) {
                    outputStream.write(buffer, 0, bytesRead);
                }
            }

            filePath = "../itemImage/" + fileName;
        }

        double price = 0.0;
        try {
            price = Double.parseDouble(String.format("%.2f", Double.parseDouble(itemPrice.trim())));
        } catch (NumberFormatException e) {
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write("{\"status\": \"invalid_price\"}");
            return;
        }

        try {
            Connection conn = DriverManager.getConnection("jdbc:derby://localhost:1527/GreenTech", "app", "app");
            String sql = "INSERT INTO item (item_name, item_price, item_pict) VALUES (?, ?, ?)";
            try (PreparedStatement statement = conn.prepareStatement(sql)) {
                statement.setString(1, itemName);
                statement.setDouble(2, price);
                statement.setString(3, filePath);

                int rowsInserted = statement.executeUpdate();
                if (rowsInserted > 0) {
                    response.setContentType("application/json");
                    response.setCharacterEncoding("UTF-8");
                    response.getWriter().write("{\"status\": \"success\", \"redirectUrl\": \"items-1.jsp\"}");
                } else {
                    response.setContentType("application/json");
                    response.setCharacterEncoding("UTF-8");
                    response.getWriter().write("{\"status\": \"error\"}");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write("{\"status\": \"db_error\"}");
        }
    }
}
