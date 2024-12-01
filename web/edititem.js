// Example data for items
const itemsData = {
    "001": {
        name: "Cardboard",
        price: "5",
        image: "images/cardboard.png"
    },
    "002": {
        name: "Newspaper",
        price: "5",
        image: "images/newpaper.png"
    },
    "003": {
        name: "Plastic Bottle",
        price: "5",
        image: "images/plasticBot.png"
    },
    "004": {
        name: "Aluminium Can",
        price: "10",
        image: "images/alCan.png"
    },
    "005": {
        name: "Glass Bottle",
        price: "15",
        image: "images/glass bottle.png"
    },
    "006": {
        name: "Used Cooking Oil",
        price: "20",
        image: "images/usedOil.png"
    }
};

// Get item_ID from URL
const urlParams = new URLSearchParams(window.location.search);
const itemId = urlParams.get("item_ID");

// Populate form with item data
if (itemId && itemsData[itemId]) {
    document.getElementById("itemid").value = itemId;
    document.getElementById("itemname").value = itemsData[itemId].name;
    document.getElementById("itemprice").value = itemsData[itemId].price;
    document.getElementById("currentitempict_img").src = itemsData[itemId].image;
    document.getElementById("currentitempict").value = itemsData[itemId].image;
} else {
    alert("Invalid item ID!");
}
