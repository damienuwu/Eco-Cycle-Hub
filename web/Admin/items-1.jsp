<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
<%@ page import="user.Session" %>
<%@ page import="javax.servlet.http.HttpSession" %>
<%@ page import="javax.servlet.http.HttpServletResponse" %>
<%
    session = request.getSession(false);
    if (session == null || !Session.isValidStaffSession(session, response)) {
        return;
    }
    int staffID = Session.getStaffID(session);
%>
<!DOCTYPE html>
<html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>EcoCycleHub | Items</title>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://unpkg.com/boxicons@2.0.7/css/boxicons.min.css" rel="stylesheet" />
        <link href="https://cdn.jsdelivr.net/npm/sweetalert2@11.4.28/dist/sweetalert2.min.css" rel="stylesheet">
        <link rel="stylesheet" href="../css/SidebarCustomer.css">
        <link rel="stylesheet" href="../css/items-1.css">

        <script type="module" src="https://unpkg.com/ionicons@5.5.2/dist/ionicons/ionicons.esm.js"></script>
        <script nomodule src="https://unpkg.com/ionicons@5.5.2/dist/ionicons/ionicons.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
        <script src="../js/SidebarAdmin.js"></script>
        <script src="../js/Topbar.js"></script>
    </head>

    <body>
        <div class="container-fluid d-flex p-0">
            <div id="sidebar"></div>
            <main class="main flex-grow-1 p-4">
                <div id="topbar"></div>
                <div class="details mt-4">
                    <div class="itemlist">
                        <div class="tableHeader d-flex justify-content-between align-items-center">
                            <h2>Item List</h2>
                            <a class="btn btn-success" onclick="openAddForm()"> <i class="bx bxs-edit"></i> Add Item</a>
                        </div>
                        <table class="table table-hover table-bordered">
                            <thead>
                                <tr>
                                    <th>Item ID</th>
                                    <th>Item Name</th>
                                    <th>Item Price per KG</th>
                                    <th>Item Picture</th>
                                    <th>Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    Connection conn = null;
                                    PreparedStatement ps = null;
                                    ResultSet rs = null;

                                    try {
                                        conn = DriverManager.getConnection("jdbc:derby://localhost:1527/GreenTech", "app", "app");
                                        String query = "SELECT item_id, item_name, item_price, item_pict FROM item";
                                        ps = conn.prepareStatement(query);
                                        rs = ps.executeQuery();

                                        while (rs.next()) {
                                            String itemId = rs.getString("item_id");
                                            String itemName = rs.getString("item_name");
                                            String itemPrice = rs.getString("item_price");
                                            String itemPicture = rs.getString("item_pict");
                                %>
                                <tr>
                                    <td><%= itemId%></td>
                                    <td><%= itemName%></td>
                                    <td>RM <%= itemPrice%></td>
                                    <td><img src="../itemImage/<%= itemPicture%>" alt="Item Picture" class="img-thumbnail" width="50"></td>
                                    <td>
                                        <a class="btn btn-warning" 
                                           onclick="openEditForm('<%= itemId%>', '<%= itemName%>', '<%= itemPrice%>', '<%= itemPicture%>')">
                                            <i class="bx bxs-edit"></i>
                                        </a>
                                    </td>
                                </tr>
                                <%
                                        }
                                    } catch (Exception e) {
                                        out.println("<tr><td colspan='5'>Error: " + e.getMessage() + "</td></tr>");
                                    } finally {
                                        if (rs != null) {
                                            try {
                                                rs.close();
                                            } catch (SQLException ignore) {
                                            }
                                        }
                                        if (ps != null) {
                                            try {
                                                ps.close();
                                            } catch (SQLException ignore) {
                                            }
                                        }
                                        if (conn != null) {
                                            try {
                                                conn.close();
                                            } catch (SQLException ignore) {
                                            }
                                        }
                                    }
                                %>
                            </tbody>
                        </table>
                    </div>

                    <!-- Edit Item Modal -->
                    <div id="EditModal" class="modal fade" tabindex="-1" aria-labelledby="EditModalLabel" aria-hidden="true">
                        <div class="modal-dialog modal-dialog-centered">
                            <div class="modal-content shadow-lg rounded-4">
                                <div class="modal-header border-0">
                                    <h5 class="modal-title" id="EditModalLabel">Item Details</h5>
                                    <button type="button" class="btn-close" aria-label="Close" onclick="closeEditForm()"></button>
                                </div>
                                <div class="modal-body">
                                    <form action="../EditItemServlet" method="post" enctype="multipart/form-data">
                                        <input type="hidden" name="currentitempict" id="currentitempict" value="">

                                        <h4 class="mb-4 text-center text-muted">Edit Item Information</h4>

                                        <div class="mb-4">
                                            <label for="itemid" class="form-label text-dark">Item ID</label>
                                            <input type="text" id="itemid" name="itemid" class="form-control form-control-lg" readonly>
                                        </div>
                                        <div class="mb-4">
                                            <label for="itemname" class="form-label text-dark">Item Name</label>
                                            <input type="text" id="itemname" name="itemname" class="form-control form-control-lg" required>
                                        </div>
                                        <div class="mb-4">
                                            <label for="itemprice" class="form-label text-dark">Item Price (RM)</label>
                                            <input type="text" id="itemprice" name="itemprice" class="form-control form-control-lg" required>
                                        </div>
                                        <div class="mb-4">
                                            <label for="itempicture" class="form-label text-dark">Item Picture</label>
                                            <div class="d-flex justify-content-center align-items-center">
                                                <img id="itempicture" width="100" alt="Item Picture" class="rounded-3 shadow-sm mb-3" onclick="document.getElementById('uploadImage').click()">
                                                <button type="button" class="btn btn-primary btn-sm ms-3" onclick="document.getElementById('uploadImage').click()">Change</button>
                                                <input name="uploadImage" type="file" id="uploadImage" class="form-control form-control-sm ms-3" onchange="previewImage(event)" accept="image/*" style="display: none;">
                                                <button type="button" class="btn btn-danger btn-sm ms-3" onclick="removeImage()">Remove Image</button>
                                            </div>
                                        </div>
                                        <div class="d-flex justify-content-between mt-4">
                                            <button type="submit" class="btn btn-success btn-lg w-100">Save Changes</button>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Add Item Modal -->
                    <div id="AddModal" class="modal fade" tabindex="-1" aria-labelledby="AddModalLabel" aria-hidden="true">
                        <div class="modal-dialog modal-dialog-centered">
                            <div class="modal-content shadow-lg rounded-4">
                                <div class="modal-header border-0">
                                    <h5 class="modal-title" id="AddModalLabel">Add Item Details</h5>
                                    <button type="button" class="btn-close" aria-label="Close" onclick="closeAddForm()"></button>
                                </div>
                                <div class="modal-body">
                                    <form id="AddForm" action="../AddItemServlet" method="post" enctype="multipart/form-data">
                                        <div class="mb-3">
                                            <label for="addItemName" class="form-label">Item Name</label>
                                            <input type="text" class="form-control" id="addItemName" name="itemname" required>
                                        </div>
                                        <div class="mb-3">
                                            <label for="addItemPrice" class="form-label">Item Price per KG</label>
                                            <input type="number" step="0.01" class="form-control" id="addItemPrice" name="itemprice" required>
                                        </div>
                                        <div class="mb-3">
                                            <label for="addItemPicture" class="form-label">Item Picture</label>
                                            <input type="file" class="form-control" id="addItemPicture" name="itempict" accept="image/*" required>
                                        </div>
                                        <div class="text-center">
                                            <button type="submit" name="submit" value="Submit" class="btn btn-success">Add Item</button>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </main>
        </div>
        <script>
            var myModal;
            function openEditForm(itemId, itemName, itemPrice, itemPicture) {
                document.getElementById('itemid').value = itemId;
                document.getElementById('itemname').value = itemName;
                document.getElementById('itemprice').value = itemPrice;
                document.getElementById('itempicture').src = "../itemImage/" + itemPicture;
                document.getElementById('currentitempict').value = itemPicture;

                myModal = new bootstrap.Modal(document.getElementById('EditModal'));
                myModal.show();
            }

            function closeEditForm() {
                if (myModal) {
                    myModal.hide();
                }
            }

            var addModal;

            function openAddForm() {
                addModal = new bootstrap.Modal(document.getElementById('AddModal'));
                addModal.show();
            }

            // Close the Add Modal
            function closeAddForm() {
                if (addModal) {
                    addModal.hide();
                }
            }
        </script>
        <script>
            function previewImage(event) {
                var reader = new FileReader();
                reader.onload = function () {
                    var output = document.getElementById('itempicture');
                    output.src = reader.result;
                };
                reader.readAsDataURL(event.target.files[0]);
            }

            function removeImage() {
                var image = document.getElementById('itempicture');
                var fileInput = document.getElementById('uploadImage');
                image.src = '';
                fileInput.value = '';
            }
        </script>
        <script>
            function handleEditFormResponse(response) {
                if (response.status === 'updated') {
                    Swal.fire({
                        icon: 'success',
                        title: 'Item Updated!',
                        text: 'The item has been updated successfully.',
                        confirmButtonText: 'OK',
                        confirmButtonColor: '#3085d6'
                    }).then(() => {
                        window.location.href = response.redirectUrl;
                    });
                } else if (response.status === 'error') {
                    Swal.fire({
                        icon: 'error',
                        title: 'Error!',
                        text: response.message || 'There was an error updating the item.',
                        confirmButtonText: 'OK',
                        confirmButtonColor: '#d33'
                    });
                }
            }

            document.querySelector('form').addEventListener('submit', function (event) {
                event.preventDefault();

                let formData = new FormData(this);

                fetch('../EditItemServlet', {
                    method: 'POST',
                    body: formData
                })
                        .then(response => response.json())
                        .then(handleEditFormResponse)
                        .catch(error => {
                            Swal.fire({
                                icon: 'error',
                                title: 'Unexpected Error!',
                                text: 'An unexpected error occurred. Please try again later.',
                                confirmButtonText: 'OK',
                                confirmButtonColor: '#d33'
                            });
                        });
            });
        </script>
        <script>
            document.addEventListener("DOMContentLoaded", function () {
                document.getElementById('AddForm').addEventListener('submit', function (event) {
                    event.preventDefault();

                    let formData = new FormData(this);

                    fetch(this.action, {
                        method: 'POST',
                        body: formData
                    })
                            .then(response => response.json())
                            .then(data => {
                                if (data.status === "success") {
                                    Swal.fire({
                                        title: 'Success!',
                                        text: data.message || 'Item added successfully!',
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
                                        text: data.message || 'An error occurred while adding the item.',
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