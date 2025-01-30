package items;

import java.io.Serializable;

public class item implements Serializable {

    private int itemId;
    private String itemName;
    private double itemPrice;
    private String itemPict;
    private double totalWeight;

    // No-argument constructor
    public item() {
    }

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

    public double getTotalWeight() {
        return totalWeight;
    }

    public void setTotalWeight(double totalWeight) {
        this.totalWeight = totalWeight;
    }

    @Override
    public boolean equals(Object obj) {
        if (this == obj) {
            return true;
        }
        if (obj == null || getClass() != obj.getClass()) {
            return false;
        }
        item other = (item) obj;
        return itemName != null && itemName.equals(other.itemName);
    }

    @Override
    public int hashCode() {
        return itemName != null ? itemName.hashCode() : 0;
    }
}
