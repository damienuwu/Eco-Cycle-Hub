package address;

import java.io.Serializable;

public class Address implements Serializable {

    private int addressId; // Corresponds to address_id
    private String houseNo; // Corresponds to house_no
    private String streetName; // Corresponds to street_name
    private String city; // Corresponds to city
    private String postcode; // Corresponds to postcode
    private String state; // Corresponds to state
    private String profilePicture; // Corresponds to profile_picture
    private int custId; // Corresponds to cust_ID

    // Default constructor
    public Address(){}

    // Parameterized constructor
    public Address(int addressId, String houseNo, String streetName, String city, String postcode, String state, String profilePicture, int custId) {
        this.addressId = addressId;
        this.houseNo = houseNo;
        this.streetName = streetName;
        this.city = city;
        this.postcode = postcode;
        this.state = state;
        this.profilePicture = profilePicture;
        this.custId = custId;
    }

    // Getters and Setters

    public int getAddressId() {
        return addressId;
    }

    public void setAddressId(int addressId) {
        this.addressId = addressId;
    }

    public String getHouseNo() {
        return houseNo;
    }

    public void setHouseNo(String houseNo) {
        this.houseNo = houseNo;
    }

    public String getStreetName() {
        return streetName;
    }

    public void setStreetName(String streetName) {
        this.streetName = streetName;
    }

    public String getCity() {
        return city;
    }

    public void setCity(String city) {
        this.city = city;
    }

    public String getPostcode() {
        return postcode;
    }

    public void setPostcode(String postcode) {
        this.postcode = postcode;
    }

    public String getState() {
        return state;
    }

    public void setState(String state) {
        this.state = state;
    }

    public String getProfilePicture() {
        return profilePicture;
    }

    public void setProfilePicture(String profilePicture) {
        this.profilePicture = profilePicture;
    }

    public int getCustId() {
        return custId;
    }

    public void setCustId(int custId) {
        this.custId = custId;
    }
    
    public String getFullAddress() {
        return houseNo + ", " + streetName + ", " + city + ", " + state + " " + postcode;
    }

    @Override
    public String toString() {
        return houseNo + ", " + streetName + ", " + city + ", " + postcode + ", " + state;
    }
}