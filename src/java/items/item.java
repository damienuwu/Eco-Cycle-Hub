package items;

import java.io.Serializable;

public class item implements Serializable {
    private int itemId;
    private String itemName;
    private double itemPrice;
    private String itemPict;

    // No-argument constructor
    public item() {}

    // Constructor with all fields
    public item(int itemId, String itemName, double itemPrice, String itemPict) {
        this.itemId = itemId;
        this.itemName = itemName;
        this.itemPrice = itemPrice;
        this.itemPict = itemPict;
    }

    // Getters and Setters
    public int getItemId() {
        return itemId;
    }

    public void setItemId(int itemId) {
        this.itemId = itemId;
    }

    public String getItemName() {
        return itemName;
    }

    public void setItemName(String itemName) {
        this.itemName = itemName;
    }

    public double getItemPrice() {
        return itemPrice;
    }

    public void setItemPrice(double itemPrice) {
        this.itemPrice = itemPrice;
    }

    public String getItemPict() {
        return itemPict;
    }

    public void setItemPict(String itemPict) {
        this.itemPict = itemPict;
    }
}