<%@ page import="java.sql.*" %>
<%@ page import="javax.servlet.http.HttpSession" %>
<%@ page import="user.Session" %>
<%@ page import="javax.servlet.http.HttpServletResponse" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    session = request.getSession(false);
    if (session == null || !Session.isValidStaffSession(session, response)) {
        return;
    }
    int staffID = Session.getStaffID(session);

    String username = "", firstName = "", lastName = "", phone = "", email = "", profilePicPath = "";

    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        conn = DriverManager.getConnection("jdbc:derby://localhost:1527/GreenTech", "app", "app");

        String sql = "SELECT staff_username, staff_first_name, staff_last_name, staff_contact_no, staff_email, profile_picture FROM Staff WHERE staff_ID = ?";
        ps = conn.prepareStatement(sql);
        ps.setInt(1, staffID);

        rs = ps.executeQuery();

        if (rs.next()) {
            username = rs.getString("staff_username");
            firstName = rs.getString("staff_first_name");
            lastName = rs.getString("staff_last_name");
            phone = rs.getString("staff_contact_no");
            email = rs.getString("staff_email");
            profilePicPath = rs.getString("profile_picture");
        }
    } catch (Exception e) {
        out.println("<div class='alert alert-danger'>Error: " + e.getMessage() + "</div>");
    } finally {
        if (rs != null) {
            rs.close();
        }
        if (ps != null) {
            ps.close();
        }
        if (conn != null) {
            conn.close();
        }
    }
%>
<!DOCTYPE html>
<html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>EcoCycleHub | Profile</title>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://unpkg.com/boxicons@2.0.7/css/boxicons.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/sweetalert2@11.5.5/dist/sweetalert2.min.css" rel="stylesheet">
        <link rel="stylesheet" href="../css/ProfileAdmin.css">
        <link rel="stylesheet" href="../css/SidebarCustomer.css">

        <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.min.js"></script>
        <script type="module" src="https://unpkg.com/ionicons@5.5.2/dist/ionicons/ionicons.esm.js"></script>
        <script nomodule src="https://unpkg.com/ionicons@5.5.2/dist/ionicons/ionicons.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
        <script src="../js/SidebarAdmin.js"></script>
        <script src="../js/Topbar.js"></script>
    </head>

    <body>
        <div class="container-fluid d-flex p-0">
            <nav id="sidebar" class="d-none d-md-block bg-light"></nav>
            <main class="main flex-grow-1 bg-light">
                <div id="topbar"></div>

                <form id="updateProfileForm" action="../AdminProfileServlet" method="post" enctype="multipart/form-data">
                    <div class="content container-fluid py-5 flex-grow-1">
                        <div class="row justify-content-center">
                            <div class="col-lg-4 col-md-5 col-sm-8">
                                <div class="text-center mb-4">
                                    <div class="position-relative d-inline-block">
                                        <%
                                            String profileImagePath = "../uploads/default.png"; // Default path
                                            if (profilePicPath != null && !profilePicPath.isEmpty() && profilePicPath.length() > 1) {
                                                profileImagePath = "../" + profilePicPath.substring(1);
                                            }
                                        %>
                                        <img id="avatar" src="<%= profileImagePath%>" alt="Avatar" class="avatar-img rounded-circle">

                                        <span class="badge bg-primary text-white change-avatar" onclick="document.getElementById('file-input').click();">Change</span>
                                        <input type="file" id="file-input" name="avatar" style="display:none;" accept="image/*" onchange="previewImage(event)">
                                    </div>
                                </div>
                            </div>
                            <div class="col-lg-6 col-md-7 col-sm-12">
                                <div class="userdata">
                                    <div class="nav-title mb-3">
                                        <h5>User Details</h5>
                                    </div>

                                    <label for="uname" class="form-label">Username</label>
                                    <input type="text" id="uname" name="username" class="form-control mb-3" value="<%= username%>" disabled>

                                    <label for="fname" class="form-label">First Name</label>
                                    <input type="text" id="fname" name="firstname" class="form-control mb-3" placeholder="Enter First Name" value="<%= firstName == null ? "" : firstName%>">

                                    <label for="lname" class="form-label">Last Name</label>
                                    <input type="text" id="lname" name="lastname" class="form-control mb-3" placeholder="Enter Last Name" value="<%= lastName == null ? "" : lastName%>">

                                    <label for="nphone" class="form-label">Phone</label>
                                    <input type="text" id="nphone" name="nophone" class="form-control mb-3" placeholder="Enter Phone Number" value="<%= phone == null ? "" : phone%>">

                                    <label for="aemail" class="form-label">Email</label>
                                    <input type="email" id="aemail" name="email" class="form-control mb-3" placeholder="Enter Email" value="<%= email == null ? "" : email%>">

                                    <div class="inp mt-4">
                                        <button name="submit" value="Submit" type="submit" class="btn btn-soft-green w-100 mt-4">Update Profile</button>
                                    </div>
                                </div>
                                </form>
                            </div>
                        </div>
                    </div>
            </main>
        </div>
        <script>
            function previewImage(event) {
                const file = event.target.files[0];
                if (file) {
                    const reader = new FileReader();
                    reader.onload = function (e) {
                        document.getElementById('avatar').src = e.target.result;
                    };
                    reader.readAsDataURL(file);
                }
            }
        </script>
        <script>
            document.addEventListener("DOMContentLoaded", function () {
                document.getElementById('updateProfileForm').addEventListener('submit', function (event) {
                    event.preventDefault();

                    let formData = new FormData(this);

                    fetch(this.action, {
                        method: 'POST',
                        body: formData
                    })
                            .then(response => {
                                return response.json();
                            })
                            .then(data => {
                                if (data.status === "success") {
                                    Swal.fire({
                                        title: 'Success!',
                                        text: data.message || 'Update Successfully!',
                                        icon: 'success',
                                        confirmButtonText: 'Continue',
                                        confirmButtonColor: '#28a745',
                                        background: '#f8f9fa'
                                    }).then((result) => {
                                        if (result.isConfirmed) {
                                            window.location.href = data.redirectUrl;
                                        }
                                    });
                                } else {
                                    Swal.fire({
                                        icon: 'error',
                                        title: 'Error!',
                                        text: data.message || 'An error occurred while updating your profile.',
                                        confirmButtonText: 'OK',
                                        confirmButtonColor: '#d33'
                                    });
                                }
                            })
                            .catch(error => {
                                console.error('Unexpected error:', error);
                                Swal.fire({
                                    icon: 'error',
                                    title: 'Unexpected Error!',
                                    text: 'An unexpected error occurred. Please try again later.',
                                    confirmButtonText: 'OK',
                                    confirmButtonColor: '#d33'
                                });
                            });
                });
            });
        </script>
    </body>
</html>