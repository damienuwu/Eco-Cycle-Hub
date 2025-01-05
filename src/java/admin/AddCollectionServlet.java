/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package admin;

import java.sql.*;
import java.math.BigDecimal;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import javax.servlet.annotation.MultipartConfig;

@MultipartConfig
public class AddCollectionServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect("../login.html");
            return;
        }
        
        String weight = request.getParameter("weight");
        String totalAmount = request.getParameter("totalAmount");
        String collectDate = request.getParameter("collectDate");
        String collectTime = request.getParameter("collectTime");
        String staffId = request.getParameter("staffId");
        String bookId = request.getParameter("bookId");
        String itemId = request.getParameter("itemId");

        System.out.println(weight);
        System.out.println(totalAmount);
        System.out.println(collectDate);
        System.out.println(collectTime);
        System.out.println(staffId);
        System.out.println(bookId);
        System.out.println(itemId);

        if (weight == null || totalAmount == null || collectDate == null || collectTime == null
                || staffId == null || bookId == null || itemId == null) {
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write("{\"status\": \"error\", \"message\": \"All fields are required.\"}");
            return;
        }
        System.out.println(weight);

        try (Connection conn = DriverManager.getConnection("jdbc:derby://localhost:1527/GreenTech", "app", "app");
                PreparedStatement ps = conn.prepareStatement(
                        "INSERT INTO COLLECTION_RECORD (collect_weight, total_amount, collect_date, collect_time, reward_status, book_id, item_id, staff_id) "
                        + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)")) {

            ps.setBigDecimal(1, new BigDecimal(weight));
            ps.setBigDecimal(2, new BigDecimal(totalAmount));
            ps.setDate(3, Date.valueOf(collectDate));
            ps.setString(4, collectTime);
            ps.setString(5, "pending");
            ps.setInt(6, Integer.parseInt(bookId));
            ps.setInt(7, Integer.parseInt(itemId));
            ps.setInt(8, Integer.parseInt(staffId));

            int rowsAffected = ps.executeUpdate();

            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            if (rowsAffected > 0) {
                response.getWriter().write("{\"status\": \"success\", \"message\": \"Collection record successfully created.\", \"redirectUrl\": \"CollectionRecords.jsp\"}");
            } else {
                response.getWriter().write("{\"status\": \"error\", \"message\": \"Failed to create collection record.\"}");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write("{\"status\": \"error\", \"message\": \"An error occurred while processing your request.\"}");
        }
    }
}
