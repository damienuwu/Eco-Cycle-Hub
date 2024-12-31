// Topbar.js
document.addEventListener("DOMContentLoaded", () => {
    // Load Topbar Content
    fetch('../Topbar.jsp')
        .then(response => response.text())
        .then(data => {
            document.getElementById('topbar').innerHTML = data;

            // Initialize the toggle functionality
            const toggle = document.querySelector(".toggle"); // Toggle button
            const navigation = document.querySelector(".navigation"); // Sidebar
            const mainContent = document.querySelector("main"); // Main content area

            toggle.onclick = function () {
                navigation.classList.toggle("collapsed");

                // Adjust main content based on sidebar state
                if (navigation.classList.contains("collapsed")) {
                    mainContent.classList.add("expanded");
                } else {
                    mainContent.classList.remove("expanded");
                }
            };
        })
        .catch(error => console.error('Error loading topbar:', error));
});