// Highlight Active Link on Hover
let list = document.querySelectorAll(".navigation li");

function activeLink() {
  list.forEach((item) => {
    item.classList.remove("hovered");
  });
  this.classList.add("hovered");
}

list.forEach((item) => item.addEventListener("mouseover", activeLink));

// Sidebar Toggle Functionality
let toggle = document.querySelector(".toggle"); // Toggle button
let navigation = document.querySelector(".navigation"); // Sidebar
let main = document.querySelector(".main"); // Main content

toggle.onclick = function () {
  // Toggle the "active" class to shrink/expand the sidebar
  navigation.classList.toggle("collapsed");
};
