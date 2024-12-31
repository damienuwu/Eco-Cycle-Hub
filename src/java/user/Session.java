package user;

import javax.servlet.http.HttpSession;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public class Session {

    // Customer session validation
    public static boolean isValidCustomerSession(HttpSession session, HttpServletResponse response) throws IOException {
        // Retrieve cust_ID directly
        String custIDString = (String) session.getAttribute("cust_ID");
        if (custIDString == null || custIDString.isEmpty()) {
            response.sendRedirect("../login.html");
            return false;
        }
        return true;
    }

    // Method to retrieve cust_ID from the session
    public static int getCustID(HttpSession session) {
        String custIDString = (String) session.getAttribute("cust_ID");
        int custID = 0;
        if (custIDString != null && !custIDString.isEmpty()) {
            try {
                custID = Integer.parseInt(custIDString);
            } catch (NumberFormatException e) {
                e.printStackTrace(); // Log the error
            }
        }
        return custID;
    }

    // Staff session validation
    public static boolean isValidStaffSession(HttpSession session, HttpServletResponse response) throws IOException {
        // Retrieve staff_ID directly
        String staffIDString = (String) session.getAttribute("staff_ID");
        if (staffIDString == null || staffIDString.isEmpty()) {
            response.sendRedirect("../login.html");
            return false;
        }
        return true;
    }

    // Method to retrieve staff_ID from the session
    public static int getStaffID(HttpSession session) {
        String staffIDString = (String) session.getAttribute("staff_ID");
        int staffID = 0;
        if (staffIDString != null && !staffIDString.isEmpty()) {
            try {
                staffID = Integer.parseInt(staffIDString);
            } catch (NumberFormatException e) {
                e.printStackTrace(); // Log the error
            }
        }
        return staffID;
    }
}