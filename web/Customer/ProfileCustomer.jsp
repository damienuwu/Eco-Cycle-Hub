<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="user.Session" %>
<%@ page import="javax.servlet.http.HttpSession" %>
<%@ page import="javax.servlet.http.HttpServletResponse" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="customer.Address" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%
    session = request.getSession(false);
    if (session == null || !Session.isValidCustomerSession(session, response)) {
        return;
    }
    int custID = Session.getCustID(session);

    String username = "", firstName = "", lastName = "", phone = "", email = "", addressDetails = "", bankName = "", accountNo = "", bankFullName = "";
    int bankId = 0;
    String houseNo = "", streetName = "", city = "", state = "", postcode = "";
    String profilePicPath = "";
    int addressid = 0;

    if (custID != 0) {

        try {
            Connection conn = DriverManager.getConnection("jdbc:derby://localhost:1527/GreenTech", "app", "app");

            //customer details
            String query = "select * FROM Customer where cust_id = ?";
            PreparedStatement ps = conn.prepareStatement(query);
            ps.setInt(1, custID);
            ResultSet customer = ps.executeQuery();
            if (customer.next()) {
                username = customer.getString("cust_username");
                firstName = customer.getString("cust_first_name");
                lastName = customer.getString("cust_last_name");
                phone = customer.getString("cust_contact_no");
                email = customer.getString("cust_email");
                bankId = customer.getInt("bank_id");
                profilePicPath = customer.getString("profile_picture");
            }

            //bank details
            if (bankId != 0) {
                String query2 = "SELECT * FROM bank_details WHERE bank_id = ?";
                PreparedStatement ps2 = conn.prepareStatement(query2);
                ps2.setInt(1, bankId);
                ResultSet bankDetails = ps2.executeQuery();
                if (bankDetails.next()) {
                    bankName = bankDetails.getString("bank_name");
                    accountNo = bankDetails.getString("bank_acc_no");
                    bankFullName = bankDetails.getString("bank_full_name");
                }
            }

            //address details
            List<Address> addresses = new ArrayList<Address>();
            String query3 = "select * FROM ADDRESS where cust_id = ?";
            PreparedStatement ps3 = conn.prepareStatement(query3);
            ps3.setInt(1, custID);
            ResultSet addressResultSet = ps3.executeQuery();
            while (addressResultSet.next()) {
                // Retrieve address fields
                houseNo = addressResultSet.getString("house_no");
                streetName = addressResultSet.getString("street_name");
                city = addressResultSet.getString("city");
                postcode = addressResultSet.getString("postcode");
                state = addressResultSet.getString("state");
                addressid = addressResultSet.getInt("address_id"); // Assume 'address_id' is the name of the column in your DB

                // Check if all required address fields are non-empty/valid
                if (houseNo != null && !houseNo.isEmpty()
                        && streetName != null && !streetName.isEmpty()
                        && city != null && !city.isEmpty()
                        && postcode != null && !city.isEmpty()
                        && state != null && !state.isEmpty()) {
                    // Create Address object if all fields are complete
                    Address addr = new Address(houseNo, streetName, city, postcode, state, addressid);
                    addresses.add(addr);
                }
            }
            request.setAttribute("addresses", addresses);

            customer.close();
//            addressResultSet.close();
            ps.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    String message = (String) session.getAttribute("message");
    String errorMessage = (String) session.getAttribute("error");
    session.removeAttribute("message"); // Clear the message after displaying
    session.removeAttribute("error"); // Clear the error message after displaying
%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Profile Page</title>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://unpkg.com/boxicons@2.0.7/css/boxicons.min.css" rel="stylesheet" />
        <link rel="stylesheet" href="../css/Profile.css">
        <link rel="stylesheet" href="../css/SidebarCustomer.css">
        <link href="https://cdn.jsdelivr.net/npm/sweetalert2@11.4.28/dist/sweetalert2.min.css" rel="stylesheet">

        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
        <script src="https://unpkg.com/ionicons@5.5.2/dist/ionicons.js"></script>
        <script src="../js/SidebarCustomer.js"></script>
        <script src="../js/Topbar.js"></script>
    </head>
    <body>
        <div class="container-fluid d-flex p-0">
            <nav id="sidebar" class="d-none d-md-block bg-light"></nav>
            <main class="main flex-grow-1 bg-light">
                <%
                    if (message != null) {
                        out.println("<div class='alert alert-success'>" + message + "</div>");
                    }
                    if (errorMessage != null) {
                        out.println("<div class='alert alert-danger'>" + errorMessage + "</div>");
                    }
                %>
                <div id="topbar"></div>
                <div class="card shadow-sm mb-4">
                    <div class="card-header text-center">
                        <h3>Profile</h3>
                    </div>
                    <div class="card-body">

                        <form id="updateProfileForm" action="../UpdateProfileServlet" method="post" enctype="multipart/form-data">
                            <!-- Profile Picture -->
                            <div class="text-center mb-4">
                                <div class="position-relative d-inline-block">
                                    <%
                                        String profileImagePath = "../uploads/default.png"; // Default path
                                        if (profilePicPath != null && !profilePicPath.isEmpty() && profilePicPath.length() > 1) {
                                            profileImagePath = "../" + profilePicPath.substring(1);
                                        }
                                    %>
                                    <img id="avatar" src="<%= profileImagePath %>" alt="Avatar" class="rounded-circle img-fluid avatar">
                                    <span class="badge bg-primary text-white change-avatar" onclick="document.getElementById('file-input').click();">Change</span>
                                    <input type="file" id="file-input" name="avatar" style="display:none;" accept="image/*" onchange="previewImage(event)">
                                </div>
                            </div>

                            <!-- Bank Details -->
                            <div class="mb-4">
                                <h4>Bank Details</h4>
                                <table class="table table-bordered">
                                    <tr>
                                        <th>Bank Full Name</th>
                                        <td>
                                            <select id="bank_full_name" name="bank_full_name" class="form-control">
                                                <option value="Please select bank" <%= bankFullName.equals("Please select bank") ? "selected" : ""%>>Please select bank</option>
                                                <option value="AmBank" <%= bankFullName.equals("AmBank") ? "selected" : ""%>>AmBank</option>
                                                <option value="Bank Islam" <%= bankFullName.equals("Bank Islam") ? "selected" : ""%>>Bank Islam</option>
                                                <option value="Bank Rakyat" <%= bankFullName.equals("Bank Rakyat") ? "selected" : ""%>>Bank Rakyat</option>
                                                <option value="CIMB Group" <%= bankFullName.equals("CIMB Group") ? "selected" : ""%>>CIMB Group</option>
                                                <option value="Maybank" <%= bankFullName.equals("Maybank") ? "selected" : ""%>>Maybank</option>
                                                <option value="RHB Bank" <%= bankFullName.equals("RHB Bank") ? "selected" : ""%>>RHB Bank</option>
                                            </select>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>Account No</th>
                                        <td><input type="text" name="accountNo" class="form-control" value="<%= accountNo != null ? accountNo : ""%>"></td>
                                    </tr>
                                    <tr>
                                        <th>Bank Name</th>
                                        <td><input type="text" name="bankName" class="form-control" value="<%= bankName != null ? bankName : ""%>"></td>
                                    </tr>
                                </table>
                            </div>

                            <!-- customer Details -->
                            <div class="mb-4">
                                <h4>User Details</h4>
                                <div class="form-group mb-3">
                                    <label for="uname">Username</label>
                                    <input type="text" class="form-control" value="<%= username%>" disabled>
                                </div>
                                <div class="form-group mb-3">
                                    <label for="fname">First Name</label>
                                    <input type="text" name="firstName" class="form-control" placeholder="Enter First Name" value="<%= firstName == null ? "" : firstName%>">
                                </div>
                                <div class="form-group mb-3">
                                    <label for="lname">Last Name</label>
                                    <input type="text" name="lastName" class="form-control" placeholder="Enter Last Name" value="<%= lastName == null ? "" : lastName%>">
                                </div>
                                <div class="form-group mb-3">
                                    <label for="nphone">Phone</label>
                                    <input type="text" name="phone" class="form-control" placeholder="Enter Phone Number" value="<%= phone == null ? "" : phone%>">
                                </div>
                                <div class="form-group mb-3">
                                    <label for="aemail">Email</label>
                                    <input type="email" id="aemail" name="email" class="form-control" placeholder="Enter Email" value="<%= email == null ? "" : email%>">
                                </div>
                            </div>
                            <div class="text-center">
                                <button type="submit" class="btn btn-primary">Update Profile</button>
                            </div>
                        </form>

                        <!-- Table with Existing Addresses -->
                        <table class="table table-bordered">
                            <thead>
                                <tr>
                                    <th>Address</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="address" items="${addresses}">
                                    <tr>
                                        <td>
                                            ${address.houseNo != null ? address.houseNo : 'N/A'},
                                            ${address.streetName != null ? address.streetName : 'N/A'},
                                            ${address.city != null ? address.city : 'N/A'},
                                            ${address.postcode != null ? address.postcode : 'N/A'},
                                            ${address.state != null ? address.state : 'N/A'}
                                        </td>
                                        <td>
                                            <button type="button" class="btn btn-primary" onclick="openEditAddressForm(${address.id}, '${address.houseNo}', '${address.streetName}', '${address.city}', ${address.postcode}, '${address.state}')">Edit</button>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>

                        <!-- Edit Address -->
                        <div id="editAddressModal" class="modal" style="display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.5); z-index: 1050;">
                            <div class="modal-dialog modal-dialog-centered">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <h5 class="modal-title">Edit Address</h5>
                                        <button type="button" class="btn-close" aria-label="Close" onclick="closeEditAddressForm()"></button>
                                    </div>
                                    <div class="modal-body">
                                        <form id="editAddressForm" action="../UpdateAddressServlet" method="post">
                                            <input type="hidden" name="addressId" id="addressId">
                                            <div class="form-group mb-3">
                                                <label for="houseNo">House No</label>
                                                <input type="text" name="houseNo" id="houseNo" class="form-control" required>
                                            </div>
                                            <div class="form-group mb-3">
                                                <label for="streetName">Street Name</label>
                                                <input type="text" name="streetName" id="streetName" class="form-control" required>
                                            </div>
                                            <div class="form-group mb-3">
                                                <label for="state">State</label>
                                                <select id="state" name="state" class="form-control" onchange="updateCityAndPostcode()" required>
                                                    <option value="Johor">Johor</option>
                                                    <option value="Kedah">Kedah</option>
                                                    <option value="Kelantan">Kelantan</option>
                                                    <option value="Kuala Lumpur">Kuala Lumpur</option>
                                                    <option value="Labuan">Labuan</option>
                                                    <option value="Melaka">Melaka</option>
                                                    <option value="Negeri Sembilan">Negeri Sembilan</option>
                                                    <option value="Perak">Perak</option>
                                                    <option value="Perlis">Perlis</option>
                                                    <option value="Pahang">Pahang</option>
                                                    <option value="Penang">Penang</option>
                                                    <option value="Sabah">Sabah</option>
                                                    <option value="Sarawak">Sarawak</option>
                                                    <option value="Selangor">Selangor</option>
                                                    <option value="Terengganu">Terengganu</option>
                                                </select>
                                            </div>
                                            <div class="form-group mb-3">
                                                <label for="city">City</label>
                                                <select id="city" name="city" class="form-control" required>
                                                    <option value="">Select City</option>
                                                    <c:forEach var="city" items="${cities}">
                                                        <option value="${city}" <c:if test="${city eq selectedCity}">selected</c:if>>${city}</option>
                                                    </c:forEach>
                                                </select>
                                            </div>
                                            <div class="form-group mb-3">
                                                <label for="postcode">Postcode</label>
                                                <select id="postcode" name="postcode" class="form-control" required>
                                                    <option value="">Select Postcode</option>
                                                    <c:forEach var="postcode" items="${postcodes}">
                                                        <option value="${postcode}" <c:if test="${postcode eq selectedPostcode}">selected</c:if>>${postcode}</option>
                                                    </c:forEach>
                                                </select>
                                            </div>
                                            <div class="text-end">
                                                <button type="button" class="btn btn-secondary me-2" onclick="closeEditAddressForm()">Cancel</button>
                                                <button type="submit" class="btn btn-success">Save Changes</button>
                                            </div>
                                        </form>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Add new Address-->
                        <div id="addAddressModal" class="modal" style="display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.5); z-index: 1050;">
                            <div class="modal-dialog modal-dialog-centered">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <h5 class="modal-title">Add New Address</h5>
                                        <button type="button" class="btn-close" aria-label="Close" onclick="closeAddAddressForm()"></button>
                                    </div>
                                    <div class="modal-body">
                                        <form action="../AddAddressServlet" method="post" enctype="multipart/form-data">
                                            <div class="form-group mb-3">
                                                <label for="houseNo">House No</label>
                                                <input type="text" name="houseNo" class="form-control" required>
                                            </div>
                                            <div class="form-group mb-3">
                                                <label for="streetName">Street Name</label>
                                                <input type="text" name="streetName" class="form-control" required>
                                            </div>
                                            <div class="form-group mb-3">
                                                <label for="state">State</label>
                                                <select id="newState" name="state" class="form-control" onchange="newUpdateCityAndPostcode()" required>
                                                    <option value="">Select State</option>
                                                    <option value="Johor" >Johor</option>
                                                    <option value="Kedah" >Kedah</option>
                                                    <option value="Kelantan" >Kelantan</option>
                                                    <option value="Kuala Lumpur" >Kuala Lumpur</option>
                                                    <option value="Labuan" >Labuan</option>
                                                    <option value="Melaka" >Melaka</option>
                                                    <option value="Negeri Sembilan" >Negeri Sembilan</option>
                                                    <option value="Perak" >Perak</option>
                                                    <option value="Perlis" >Perlis</option>
                                                    <option value="Pahang" >Pahang</option>
                                                    <option value="Penang" >Penang</option>
                                                    <option value="Sabah" >Sabah</option>
                                                    <option value="Sarawak" >Sarawak</option>
                                                    <option value="Selangor" >Selangor</option>
                                                    <option value="Terengganu" >Terengganu</option>
                                                </select>
                                            </div>
                                            <div class="form-group mb-3">
                                                <label for="city">City</label>
                                                <select id="newCity" name="city" class="form-control" required>
                                                    <option value="">Select City</option>
                                                    <c:forEach var="city" items="${cities}">
                                                        <option value="${city}" <c:if test="${city eq selectedCity}">selected</c:if>>${city}</option>
                                                    </c:forEach>
                                                </select>
                                            </div>
                                            <div class="form-group mb-3">
                                                <label for="postcode">Postcode</label>
                                                <select id="newPostcode" name="postcode" class="form-control" required>
                                                    <option value="">Select Postcode</option>
                                                    <c:forEach var="postcode" items="${postcodes}">
                                                        <option value="${postcode}" <c:if test="${postcode eq selectedPostcode}">selected</c:if>>${postcode}</option>
                                                    </c:forEach>
                                                </select>
                                            </div>
                                            <div class="text-end">
                                                <button type="button" class="btn btn-secondary me-2" onclick="closeAddAddressForm()">Cancel</button>
                                                <button type="submit" class="btn btn-success">Save Address</button>
                                            </div>
                                        </form>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <button type="button" class="btn btn-primary" onclick="showAddAddressForm()">Add Address</button>
                    </div>
                </div>
        </div>
    </main>
</div>
<script>
    // List of state, cities, postcodes
    const locations = {
        "Johor": {
            "Johor Bahru": ["80000", "80100", "80200"],
            "Kulai": ["81000", "81100"],
            "Mersing": ["86800", "86900"],
            "Segamat": ["85000", "85100"]
        },
        "Kedah": {
            "Alor Setar": ["05000", "05100", "05200"],
            "Kulim": ["09000", "09100"],
            "Langkawi": ["07000", "07100"],
            "Sungai Petani": ["08000", "08100"]
        },
        "Kelantan": {
            "Kota Bharu": ["15000", "15100", "15200"],
            "Pasir Mas": ["17000", "17100"],
            "Tumpat": ["16000", "16100"]
        },
        "Kuala Lumpur": {
            "Bandar Tun Razak": ["56010"],
            "Cheras": ["56000", "56100", "56150"],
            "Kuala Lumpur": ["50000", "50200", "50300"],
            "Setapak": ["53000", "53100"],
            "Titiwangsa": ["50400", "50500"]
        },
        "Labuan": {
            "Labuan": ["87000", "87100"]
        },
        "Melaka": {
            "Alor Gajah": ["78000", "78100"],
            "Jasin": ["77000", "77100"],
            "Melaka City": ["75000", "75100"]
        },
        "Negeri Sembilan": {
            "Port Dickson": ["71000", "71100"],
            "Rembau": ["71300", "71400"],
            "Seremban": ["70000", "70100", "70200"]
        },
        "Pahang": {
            "Kuantan": ["25000", "25100", "25200"],
            "Pekan": ["26600", "26700"],
            "Temerloh": ["28000", "28100"]
        },
        "Perak": {
            "Ipoh": ["30000", "30100", "30200"],
            "Kuala Kangsar": ["33000", "33100"],
            "Sitiawan": ["32000", "32100"],
            "Taiping": ["34000", "34100"]
        },
        "Perlis": {
            "Arau": ["02600", "02700"],
            "Kangar": ["01000", "01100"]
        },
        "Penang": {
            "Bayan Lepas": ["11900", "11910", "11920"],
            "Bukit Mertajam": ["14000", "14100", "14200"],
            "Butterworth": ["12000", "12100"],
            "Georgetown": ["10000", "10100", "10200"]
        },
        "Sabah": {
            "Keningau": ["89000", "89100"],
            "Kota Kinabalu": ["88000", "88100", "88200"],
            "Sandakan": ["90000", "90100"],
            "Tawau": ["91000", "91100"]
        },
        "Sarawak": {
            "Bintulu": ["97000", "97100"],
            "Kuching": ["93000", "93100", "93200"],
            "Miri": ["98000", "98100"],
            "Sibu": ["96000", "96100"]
        },
        "Selangor": {
            "Ampang": ["68000", "68100"],
            "Klang": ["41000", "41100", "41200"],
            "Petaling Jaya": ["46200", "46300", "47400"],
            "Puchong": ["47100", "47110"],
            "Shah Alam": ["40000", "40200", "40300"],
            "Subang Jaya": ["47500", "47600", "47610"]
        },
        "Terengganu": {
            "Kemaman": ["24000", "24100"],
            "Dungun": ["23000", "23100"],
            "Kuala Terengganu": ["20000", "20100", "20200"]
        }
    };
</script>

<script>
    //use on update address
    let previousState = null;
    function updateCityAndPostcode(selectedCity = "", selectedPostcode = "") {
        const state = document.getElementById("state").value;
        const cityDropdown = document.getElementById("city");
        const postcodeDropdown = document.getElementById("postcode");

        cityDropdown.innerHTML = "<option value=''>Select City</option>";
        postcodeDropdown.innerHTML = "<option value=''>Select Postcode</option>";

        if (state && locations[state]) {
            // Populate the city dropdown
            Object.keys(locations[state]).forEach(city => {
                const option = document.createElement("option");
                option.value = city;
                option.text = city;
                cityDropdown.appendChild(option);
            });
            if (selectedCity) {
                cityDropdown.value = selectedCity;
            }
        }

        if (selectedCity && locations[state] && locations[state][selectedCity]) {
            locations[state][selectedCity].forEach(postcode => {
                const option = document.createElement("option");
                option.value = postcode;
                option.text = postcode;
                postcodeDropdown.appendChild(option);
            });
            if (selectedPostcode) {
                postcodeDropdown.value = selectedPostcode;
            }
        }

        cityDropdown.onchange = function () {
            const city = cityDropdown.value;
            postcodeDropdown.innerHTML = "<option value=''>Select Postcode</option>";

            if (city && locations[state] && locations[state][city]) {
                locations[state][city].forEach(postcode => {
                    const option = document.createElement("option");
                    option.value = postcode;
                    option.text = postcode;
                    postcodeDropdown.appendChild(option);
                });
            }
        };
    }

    window.onload = function () {
        updateCityAndPostcode();
    };
</script>

<script>
    // use on add new address
    function newUpdateCityAndPostcode() {
        const stateDropdown = document.getElementById("newState");
        const cityDropdown = document.getElementById("newCity");
        const postcodeDropdown = document.getElementById("newPostcode");

        setTimeout(() => {
            const state = stateDropdown.value;

            cityDropdown.innerHTML = "<option value=''>Select City</option>";
            postcodeDropdown.innerHTML = "<option value=''>Select Postcode</option>";

            if (state && locations[state]) {
                Object.keys(locations[state]).forEach(city => {
                    const option = document.createElement("option");
                    option.value = city;
                    option.text = city;
                    cityDropdown.appendChild(option);
                });

                cityDropdown.onchange = function () {
                    const city = cityDropdown.value;
                    postcodeDropdown.innerHTML = "<option value=''>Select Postcode</option>";

                    if (city && locations[state] && locations[state][city]) {
                        locations[state][city].forEach(postcode => {
                            const option = document.createElement("option");
                            option.value = postcode;
                            option.text = postcode;
                            postcodeDropdown.appendChild(option);
                        });
                    }
                };
            }
        }, 100);
    }

    window.onload = function () {
        newUpdateCityAndPostcode(); // Call this function to populate cities initially
    };
</script>
<script>
    function showAddAddressForm() {
        document.getElementById('addAddressModal').style.display = 'block';
    }
    function closeAddAddressForm() {
        document.getElementById('addAddressModal').style.display = 'none';
    }
    function openEditAddressForm(addressId, houseNo, streetName, city, postcode, state) {
        document.getElementById('addressId').value = addressId;
        document.getElementById('houseNo').value = houseNo;
        document.getElementById('streetName').value = streetName;
        document.getElementById('state').value = state;
        document.getElementById('editAddressModal').style.display = 'block';

        updateCityAndPostcode(city, postcode);
    }

    function closeEditAddressForm() {
        document.getElementById('editAddressModal').style.display = 'none';
    }
</script>

<script>
    document.getElementById('updateProfileForm').addEventListener('submit', function (event) {
        event.preventDefault();

        let formData = new FormData(this);

        let xhr = new XMLHttpRequest();
        xhr.open('POST', this.action, true);
        xhr.onload = function () {
            if (xhr.status === 200) {
                let newProfilePicPath = xhr.responseText;
                document.getElementById('avatar').src = newProfilePicPath;
            } else {
                alert('Error uploading image');
            }
        };
        xhr.send(formData);
    });
</script>

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

            Swal.fire({
                title: 'Processing...',
                text: 'Please wait a moment.',
                icon: 'info',
                showConfirmButton: false,
                allowOutsideClick: false,
                timer: 2000,
            });

            setTimeout(() => {
                this.submit();
            }, 2000);
        });
    });
</script>
</body>
</html>