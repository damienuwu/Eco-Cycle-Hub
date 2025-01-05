/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package admin;

import java.math.BigDecimal;
import java.sql.Date;

/**
 *
 * @author damie
 */
public class CollectionRecord {

    private int collectId;
    private BigDecimal collectWeight;
    private BigDecimal totalAmount;
    private Date collectDate;
    private String collectTime;
    private String rewardStatus;
    private int bookId;
    private int itemId;
    private int staffId;
    private String staffName;
    private String itemName;

    public CollectionRecord(int collectId, BigDecimal collectWeight, BigDecimal totalAmount,
            Date collectDate, String collectTime, String rewardStatus,
            int bookId, int itemId, int staffId, String staffName, String itemName) {
        this.collectId = collectId;
        this.collectWeight = collectWeight;
        this.totalAmount = totalAmount;
        this.collectDate = collectDate;
        this.collectTime = collectTime;
        this.rewardStatus = rewardStatus;
        this.bookId = bookId;
        this.itemId = itemId;
        this.staffId = staffId;
        this.staffName = staffName;
        this.itemName = itemName;
    }

    // Getters and setters
    public int getCollectId() {
        return collectId;
    }

    public BigDecimal getCollectWeight() {
        return collectWeight;
    }

    public BigDecimal getTotalAmount() {
        return totalAmount;
    }

    public Date getCollectDate() {
        return collectDate;
    }

    public String getCollectTime() {
        return collectTime;
    }

    public String getRewardStatus() {
        return rewardStatus;
    }

    public int getBookId() {
        return bookId;
    }

    public int getItemId() {
        return itemId;
    }

    public int getStaffId() {
        return staffId;
    }

    public String getItemName() {
        return itemName;
    }

    public String getStaffName() {
        return staffName;
    }

    public void setCollectId(int collectId) {
        this.collectId = collectId;
    }

    public void setCollectWeight(BigDecimal collectWeight) {
        this.collectWeight = collectWeight;
    }

    public void setTotalAmount(BigDecimal totalAmount) {
        this.totalAmount = totalAmount;
    }

    public void setCollectDate(Date collectDate) {
        this.collectDate = collectDate;
    }

    public void setCollectTime(String collectTime) {
        this.collectTime = collectTime;
    }

    public void setRewardStatus(String rewardStatus) {
        this.rewardStatus = rewardStatus;
    }

    public void setBookId(int bookId) {
        this.bookId = bookId;
    }

    public void setItemId(int itemId) {
        this.itemId = itemId;
    }

    public void setStaffId(int staffId) {
        this.staffId = staffId;
    }

    public void setItemName(String itemName) {
        this.itemName = itemName;
    }

    public void setStaffName(String staffName) {
        this.staffName = staffName;
    }
    
}
