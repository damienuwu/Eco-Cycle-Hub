package booking;

import java.sql.Date;

public class Booking {

    private int bookingId;
    private String vehicleType;
    private Date pickupDate;
    private String pickupTime;
    private String depositReceipt;
    private String depositStatus;
    private String bookStatus;
    private int custId;
    private int addressId;

    // Default constructor
    public Booking() {
    }

    // Constructor with all fields
    public Booking(int bookingId, String vehicleType, Date pickupDate, String pickupTime,
            String depositReceipt, String depositStatus, String bookStatus,
            int custId, int addressId) {
        this.bookingId = bookingId;
        this.vehicleType = vehicleType;
        this.pickupDate = pickupDate;
        this.pickupTime = pickupTime;
        this.depositReceipt = depositReceipt;
        this.depositStatus = depositStatus;
        this.bookStatus = bookStatus;
        this.custId = custId;
        this.addressId = addressId;
    }

    // Getters and Setters
    public int getBookingId() {
        return bookingId;
    }

    public void setBookingId(int bookingId) {
        this.bookingId = bookingId;
    }

    public String getVehicleType() {
        return vehicleType;
    }

    public void setVehicleType(String vehicleType) {
        this.vehicleType = vehicleType;
    }

    public Date getPickupDate() {
        return pickupDate;
    }

    public void setPickupDate(Date pickupDate) {
        this.pickupDate = pickupDate;
    }

    public String getPickupTime() {
        return pickupTime;
    }

    public void setPickupTime(String pickupTime) {
        this.pickupTime = pickupTime;
    }

    public String getDepositReceipt() {
        return depositReceipt;
    }

    public void setDepositReceipt(String depositReceipt) {
        this.depositReceipt = depositReceipt;
    }

    public String getDepositStatus() {
        return depositStatus;
    }

    public void setDepositStatus(String depositStatus) {
        this.depositStatus = depositStatus;
    }

    public String getBookStatus() {
        return bookStatus;
    }

    public void setBookStatus(String bookStatus) {
        this.bookStatus = bookStatus;
    }

    public int getCustId() {
        return custId;
    }

    public void setCustId(int custId) {
        this.custId = custId;
    }

    public int getAddressId() {
        return addressId;
    }

    public void setAddressId(int addressId) {
        this.addressId = addressId;
    }
}
