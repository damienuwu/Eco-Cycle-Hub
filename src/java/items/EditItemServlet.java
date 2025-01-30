package items;

import java.io.*;
import javax.servlet.*;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.*;
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

            itemDAO dao = new itemDAO();
            dao.updateItem(itemId, itemName, itemPrice, newItemPict);

            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write("{\"status\": \"updated\", \"redirectUrl\": \"items-1.jsp\"}");
        } catch (NumberFormatException e) {
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write("{\"status\": \"error\", \"message\": \"Invalid price format\"}");
        } catch (Exception e) {
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write("{\"status\": \"error\", \"message\": \"An error occurred: " + e.getMessage() + "\"}");
        }
    }
}