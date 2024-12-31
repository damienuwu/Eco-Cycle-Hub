<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="user.Session" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>

<%
    session = request.getSession(false);
    if (session == null || !Session.isValidCustomerSession(session, response)) {
        return;
    }
    int custID = Session.getCustID(session);

    String address = "", houseNo = "", streetName = "", city = "", state = "";
    int addressID = 0, postcode = 0;

    // Fetch addresses for the customer
    List<String> addressList = new ArrayList<String>();
    List<Integer> addressListID = new ArrayList<Integer>();

    try {
        Connection conn = DriverManager.getConnection("jdbc:derby://localhost:1527/GreenTech", "app", "app");
        String sql = "SELECT * FROM address WHERE cust_id = ?";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setInt(1, custID);
        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            addressID = rs.getInt("address_id");
            houseNo = rs.getString("house_no");
            streetName = rs.getString("street_name");
            city = rs.getString("city");
            postcode = rs.getInt("postcode");
            state = rs.getString("state");

            StringBuilder addressBuilder = new StringBuilder();

            if (houseNo != null && !houseNo.isEmpty()) {
                addressBuilder.append(houseNo);
            }
            if (streetName != null && !streetName.isEmpty()) {
                if (addressBuilder.length() > 0) {
                    addressBuilder.append(", ");
                }
                addressBuilder.append(streetName);
            }
            if (city != null && !city.isEmpty()) {
                if (addressBuilder.length() > 0) {
                    addressBuilder.append(", ");
                }
                addressBuilder.append(city);
            }
            if (postcode != 0) {
                if (addressBuilder.length() > 0) {
                    addressBuilder.append(", ");
                }
                addressBuilder.append(postcode);
            }
            if (state != null && !state.isEmpty()) {
                if (addressBuilder.length() > 0) {
                    addressBuilder.append(", ");
                }
                addressBuilder.append(state);
            }

            if (addressBuilder.length() > 0) {
                addressList.add(addressBuilder.toString());
                addressListID.add(addressID);
            }
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>EcoCycleHub | Dashboard</title>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
        <link href="https://unpkg.com/boxicons@2.0.7/css/boxicons.min.css" rel="stylesheet" />
        <link rel="stylesheet" href="../css/Dashboard.css">
        <link rel="stylesheet" href="../css/SidebarCustomer.css">

        <script src="https://unpkg.com/ionicons@5.5.2/dist/ionicons.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
        <script src="../js/SidebarCustomer.js"></script>
        <script src="../js/Topbar.js"></script>

    </head>
    <body>
        <div class="container-fluid d-flex p-0">
            <nav id="sidebar"></nav>
            <main class="main flex-grow-1 bg-light">
                <div id="topbar"></div>
                <div class="container-fluid py-3">
                    <h3 class="text-center">Dashboard</h3>
                    <div class="content d-flex flex-column align-items-center">
                        <div class="dashboard w-100 text-center">
                            <div class="top-item item text-white rounded p-3 shadow-sm">
                                <p>Total Rewards</p>
                                <h2>17.50</h2>
                                <p>RM</p>
                            </div>
                            <div class="bottom-row row justify-content-center mt-4">
                                <div class="col-12 col-md-4 col-lg-3 mb-3">
                                    <div class="item bg-white rounded p-3 shadow-sm">
                                        <p>Bottle</p>
                                        <h2>0</h2>
                                        <p>KG</p>
                                    </div>
                                </div>
                                <div class="col-12 col-md-4 col-lg-3 mb-3">
                                    <div class="item bg-white rounded p-3 shadow-sm">
                                        <p>Aluminium Can</p>
                                        <h2>0</h2>
                                        <p>KG</p>
                                    </div>
                                </div>
                                <div class="col-12 col-md-4 col-lg-3 mb-3">
                                    <div class="item bg-white rounded p-3 shadow-sm">
                                        <p>Used Cooking Oil</p>
                                        <h2>0</h2>
                                        <p>KG</p>
                                    </div>
                                </div>
                            </div>
                            <button class="recycle-btn btn btn-success mt-4 px-5 py-2" onclick="openBookingForm()">Recycle More</button>
                        </div>
                    </div>
                </div>
            </main>
        </div>

        <!-- Booking Form Modal -->
        <div id="bookingModal" class="modal" style="display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.5); z-index: 1050;">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Book Vehicle to Recycle</h5>
                        <button type="button" class="btn-close" aria-label="Close" onclick="closeBookingForm()"></button>
                    </div>
                    <div class="modal-body">
                        <form id="bookingForm" action="../SubmitBookingServlet" method="post" enctype="multipart/form-data">
                            <div class="mb-3">
                                <label for="pickupAddress" class="form-label">Pick Up Address</label>
                                <textarea name="pickupAddress" id="pickupAddress" class="form-control" readonly style="text-align: left;"><%= addressList.isEmpty() ? "No address found." : addressList.get(0) %></textarea>
                                <input type="hidden" name="address_id" id="address_id" value="<%= addressList.isEmpty() ? 0 : addressListID.get(0) %>">
                                <button type="button" class="btn btn-outline-secondary mt-2" onclick="openChangeAddressModal()">Change</button>
                            </div>

                            <div class="mb-3">
                                <label for="vehicle" class="form-label">Type of Vehicle</label>
                                <select name="vehicle" id="vehicle" class="form-select" required>
                                    <option value="">Select Vehicle Type</option>
                                    <option value="Motorcycle">Motorcycle</option>
                                    <option value="Car">Car</option>
                                    <option value="Lorry">Lorry</option>
                                </select>
                            </div>
                            <div class="mb-3">
                                <label for="pickupTime" class="form-label">Pick Up Time</label>
                                <select name="pickupTime" id="pickupTime" class="form-select">
                                    <option value="Immediately">Immediately</option>
                                    <option value="30m">Pickup in 30 minutes</option>
                                    <option value="1h">Pickup in 1 hour</option>
                                </select>
                            </div>
                            <div class="text-end">
                                <button type="button" class="btn btn-secondary me-2" onclick="closeBookingForm()">Cancel</button>
                                <button type="button" class="btn btn-primary" onclick="validateBookingForm()">Continue</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>

        <!-- Change Address Modal -->
        <div id="changeAddressModal" class="modal" style="display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.5); z-index: 1050;">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Change Address</h5>
                        <button type="button" class="btn-close" aria-label="Close" onclick="closeChangeAddressModal()"></button>
                    </div>
                    <div class="modal-body">
                        <h2>My Address</h2>
                        <hr class="adrdivision">
                        <div class="tbladdr">
                            <table border="0" class="table">
                                <% for (int i = 0; i < addressList.size(); i++) {%>
                                <tr>
                                    <td>
                                        <input type="radio" name="selected_address" value="<%= addressListID.get(i)%>" 
                                               onclick="updateAddress('<%= addressList.get(i)%>', '<%= addressListID.get(i)%>')">
                                    </td>
                                    <td>
                                        <div class="addr-info">
                                            <p class="address"><%= addressList.get(i)%></p>
                                        </div>
                                    </td>
                                </tr>
                                <% }%>
                                <tr>
                                    <td colspan="2">
                                        <hr class="adrdivision">
                                    </td>
                                </tr>
                            </table>
                        </div>
                        <div class="text-end">
                            <button type="button" class="btn btn-secondary me-2" onclick="closeChangeAddressModal()">Cancel</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Payment Form Modal -->
        <div id="paymentModal" class="modal" style="display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.5); z-index: 1050;">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="btn btn-link" onclick="backToBookingForm()" style="position: absolute; left: 10px;">
                            <i class="fa fa-chevron-left" style="color: black;"></i>
                        </button>
                        <h5 class="modal-title" style="text-align: center; flex-grow: 1;">Pay Deposit</h5>
                        <button type="button" class="btn-close" aria-label="Close" onclick="closePaymentForm()"></button>
                    </div>
                    <div class="modal-body" style="font-size: 18px;">
                        <form id="paymentForm" action="../SubmitBookingServlet" method="post" enctype="multipart/form-data">
                            <div class="paymentform">
                                <div class="row mb-4 justify-content-center">
                                    <div class="col-12 text-center">
                                        <h2 class="fs-3">Pay Deposit</h2>
                                    </div>
                                    <div class="col-12 col-md-4 d-flex justify-content-center">
                                        <img src="../images/Qrcode.png" class="paymentimg img-fluid" style="max-width: 250px; max-height: 250px;">
                                    </div>
                                </div>

                                <div class="mb-3">
                                    <label for="file" class="form-label">Proof of Payment</label>
                                    <div class="input-group">
                                        <input class="form-control" type="file" id="file" name="file" accept=".pdf" required>
                                        <span class="input-group-text"><i class="fa fa-download" aria-hidden="true"></i></span>
                                    </div>
                                    <small class="form-text text-muted">Please pay RM5 for the booking deposit.</small>
                                </div>

                                <div class="mb-3">
                                    <p>Notes: The deposit will be received with rewards after the items are successfully collected.</p>
                                </div>

                                <div class="mb-3">
                                    <div class="form-check">
                                        <input class="form-check-input" type="checkbox" id="agreement1" name="agreement1" value="Agree1" required>
                                        <label class="form-check-label" for="agreement1">
                                            I agree that the receipt uploaded is true
                                        </label>
                                    </div>
                                    <div class="form-check">
                                        <input class="form-check-input" type="checkbox" id="agreement2" name="agreement2" value="Agree2" required>
                                        <label class="form-check-label" for="agreement2">
                                            I agree that if I cancel my booking, I will not receive my deposit
                                        </label>
                                    </div>
                                </div>
                                <input type="hidden" name="pickupAddress" id="hiddenPickupAddress">
                                <input type="hidden" name="vehicle" id="hiddenVehicle">
                                <input type="hidden" name="pickupTime" id="hiddenPickupTime">
                                <input type="hidden" name="address_id" id="hiddenAddressID">
                                <div class="d-flex justify-content-center mt-4">
                                    <button type="button" id="btnCancel" class="btn btn-secondary me-3" onclick="closePaymentForm()">Cancel</button>
                                    <button type="submit" name="submit" value="Submit" class="btn btn-primary">Submit</button>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </body>
    <script>
        function openBookingForm() {
            document.getElementById('bookingModal').style.display = 'block';
        }

        function closeBookingForm() {
            document.getElementById('bookingModal').style.display = 'none';
        }

        function backToBookingForm() {
            document.getElementById('paymentModal').style.display = 'none';
            document.getElementById('bookingModal').style.display = 'block';
        }

        function openChangeAddressModal() {
            document.getElementById('changeAddressModal').style.display = 'block';
        }

        function closeChangeAddressModal() {
            document.getElementById('changeAddressModal').style.display = 'none';
        }

        function updateAddress(address, addressId) {
            document.getElementById('address_id').value = addressId;
            document.getElementById('pickupAddress').value = address;
            closeChangeAddressModal();
        }

        function openPaymentForm() {
            const vehicleType = document.getElementById("vehicle").value;
            const pickupAddress = document.getElementById("pickupAddress").value;
            const pickupTime = document.getElementById("pickupTime").value;
            const address_id = document.getElementById("address_id").value;

            if (!vehicleType) {
                Swal.fire({
                    title: 'Oops!',
                    text: 'Please select a vehicle type.',
                    icon: 'warning',
                    confirmButtonText: 'Okay',
                    confirmButtonColor: '#007bff',
                    background: '#f8f9fa',
                });
                return;
            }

            document.getElementById("hiddenVehicle").value = vehicleType;
            document.getElementById("hiddenPickupAddress").value = pickupAddress;
            document.getElementById("hiddenPickupTime").value = pickupTime;
            document.getElementById("hiddenAddressID").value = address_id;

            document.getElementById("bookingModal").style.display = "none";
            document.getElementById("paymentModal").style.display = "block";
        }

        function closePaymentForm() {
            document.getElementById('paymentModal').style.display = 'none'; // Close the payment form
        }
    </script>
    <script>
        function validateBookingForm() {
            const pickupAddress = document.getElementById('pickupAddress').value.trim();

            if (!pickupAddress) {
                Swal.fire({
                    title: "No Address Selected",
                    text: "Please select or add a pick-up address before continuing.",
                    icon: "warning",
                    confirmButtonText: "Okay"
                });
                return false;
            }

            openPaymentForm();
        }
    </script>
    <script>
        document.getElementById('paymentForm').addEventListener('submit', function (event) {
            event.preventDefault();

            const formData = new FormData(this);

            fetch(this.action, {
                method: "POST",
                body: formData,
            })
                    .then(response => response.json())
                    .then(data => {
                        if (data.status === "success") {
                            Swal.fire({
                                title: 'Success!',
                                text: data.message,
                                icon: 'success',
                                confirmButtonText: 'Return to Dashboard',
                                confirmButtonColor: '#28a745',
                                background: '#f8f9fa',
                            }).then((result) => {
                                if (result.isConfirmed) {
                                    window.location.href = data.redirectUrl;
                                }
                            });
                        } else {
                            Swal.fire({
                                title: 'Error!',
                                text: data.message,
                                icon: 'error',
                                confirmButtonText: 'Try Again',
                                confirmButtonColor: '#dc3545',
                                background: '#f8f9fa',
                            });
                        }
                    })
                    .catch(error => {
                        Swal.fire({
                            title: 'Error!',
                            text: 'An error occurred. Please try again later.',
                            icon: 'error',
                            confirmButtonText: 'Okay',
                            confirmButtonColor: '#dc3545',
                            background: '#f8f9fa',
                        });
                    });
        });
    </script>
</html>