package customer;

public class Address {
    private String houseNo;
    private String streetName;
    private String city;
    private String postcode;
    private String state;
    private int id;  // Add an 'id' property

    // Constructor
    public Address(String houseNo, String streetName, String city, String postcode, String state, int id) {
        this.houseNo = houseNo;
        this.streetName = streetName;
        this.city = city;
        this.postcode = postcode;
        this.state = state;
        this.id = id;
    }

    // Getter and Setter for 'id'
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    // Getters and setters for other properties
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
}