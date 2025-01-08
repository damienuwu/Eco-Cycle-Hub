package customer;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.nio.file.Paths;
import javax.servlet.annotation.MultipartConfig;
import user.Session;

@MultipartConfig()
public class UpdateProfileServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || !Session.isValidCustomerSession(session, response)) {
            return;
        }
        int custID = Session.getCustID(session);

        String username = (String) request.getSession().getAttribute("cust_username");
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String phone = request.getParameter("phone");
        String email = request.getParameter("email");
        String bankName = request.getParameter("bankName");
        String accountNo = request.getParameter("accountNo");
        String bank_full_name = request.getParameter("bank_full_name");

        Part filePart = request.getPart("avatar");
        String filePath = null;
        if (filePart
                != null && filePart.getSize()
                > 0) {
            String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();

            String uploadPath = "C:\\Users\\user\\Documents\\NetBeansProjects\\Eco-Cycle-Hub\\web\\uploads";
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

            String updateQuery = "UPDATE customer SET cust_first_name = ?, cust_last_name = ?, cust_contact_no = ?, cust_email = ? WHERE cust_id = ?";
            PreparedStatement ps = conn.prepareStatement(updateQuery);
            ps.setString(1, firstName);
            ps.setString(2, lastName);
            ps.setString(3, phone);
            ps.setString(4, email);
            ps.setInt(5, custID);

            int rowsUpdated = ps.executeUpdate();
            
            String selectBankIdQuery = "SELECT bank_id FROM customer WHERE cust_id = ?";
            PreparedStatement ps2 = conn.prepareStatement(selectBankIdQuery);
            ps2.setInt(1, custID);
            ResultSet rs = ps2.executeQuery();
            int bankID = 0;
            if (rs.next()) {
                bankID = rs.getInt("bank_id");
            }

            if (bankID != 0) {
                String updateBankQuery = "update bank_details SET bank_name = ?, bank_acc_no = ?, bank_full_name = ? WHERE bank_id = ?";
                PreparedStatement ps3 = conn.prepareStatement(updateBankQuery);
                ps3.setString(1, bankName);
                ps3.setString(2, accountNo);
                ps3.setString(3, bank_full_name);
                ps3.setInt(4, bankID);
                ps3.executeUpdate();
                ps3.close();
            }

            if (filePath != null) {
                String updateProfileQuery = "UPDATE customer SET profile_picture = ? WHERE cust_id = ?";
                PreparedStatement ps6 = conn.prepareStatement(updateProfileQuery);
                ps6.setString(1, filePath);
                ps6.setInt(2, custID);
                ps6.executeUpdate();
                ps6.close();
            }

            rs.close();
            ps.close();
            ps2.close();
            conn.close();

            if (rowsUpdated > 0) {
                request.getSession().setAttribute("message", "Profile updated successfully.");
                response.sendRedirect("Customer/ProfileCustomer.jsp");
            } else {
                request.getSession().setAttribute("message", "Failed to update profile. No changes were made.");
            }

        } catch (SQLException e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "Database error: " + e.getMessage());
            response.sendRedirect("Customer/ProfileCustomer.jsp");
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "An error occurred while updating the profile.");
            response.sendRedirect("Customer/ProfileCustomer.jsp");
        }
    }
}