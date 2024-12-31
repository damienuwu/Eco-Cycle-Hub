package admin;

import java.io.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.File;
import java.nio.file.Paths;
import javax.servlet.annotation.MultipartConfig;
import user.Session;

@MultipartConfig
public class AdminProfileServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || !Session.isValidStaffSession(session, response)) {
            return;
        }
        int staffID = Session.getStaffID(session);

        String firstName = request.getParameter("firstname");
        String lastName = request.getParameter("lastname");
        String phone = request.getParameter("nophone");
        String email = request.getParameter("email");

        Part filePart = request.getPart("avatar");
        String filePath = null;
        if (filePart != null && filePart.getSize() > 0) {
            String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();

            String uploadPath = "C:\\Users\\user\\Documents\\NetBeansProjects\\EcoCycleHub\\web\\uploads";
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

            filePath = "/uploads/" + fileName;
        }

        try {
            Connection conn = DriverManager.getConnection("jdbc:derby://localhost:1527/GreenTech", "app", "app");

            String updateQuery = "UPDATE staff SET staff_first_name = ?, staff_last_name = ?, staff_contact_no = ?, staff_email = ?, profile_picture = ? WHERE staff_id= ?";
            PreparedStatement ps = conn.prepareStatement(updateQuery);
            if (filePath != null) {
                updateQuery = "UPDATE staff SET staff_first_name = ?, staff_last_name = ?, staff_contact_no = ?, staff_email = ?, profile_picture = ? WHERE staff_id = ?";
                ps = conn.prepareStatement(updateQuery);
                ps.setString(1, firstName);
                ps.setString(2, lastName);
                ps.setString(3, phone);
                ps.setString(4, email);
                ps.setString(5, filePath);
                ps.setInt(6, staffID);
            } else {
                updateQuery = "UPDATE staff SET staff_first_name = ?, staff_last_name = ?, staff_contact_no = ?, staff_email = ? WHERE staff_id = ?";
                ps = conn.prepareStatement(updateQuery);
                ps.setString(1, firstName);
                ps.setString(2, lastName);
                ps.setString(3, phone);
                ps.setString(4, email);
                ps.setInt(5, staffID);
            }

            int rowsUpdated = ps.executeUpdate();

            ps.close();
            conn.close();

            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            if (rowsUpdated > 0) {
                response.getWriter().write("{\"status\": \"success\", \"message\": \"Profile updated successfully!\", \"redirectUrl\": \"ProfileAdmin.jsp\"}");
            } else {
                response.getWriter().write("{\"status\": \"error\", \"message\": \"Failed to update profile.\"}");
            }

        } catch (SQLException e) {
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write("{\"status\": \"db_error\", \"message\": \"Database error occurred.\"}");
        } catch (Exception e) {
            e.printStackTrace();
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write("{\"status\": \"error\", \"message\": \"An error occurred while updating the profile.\"}");
        }
    }
}
