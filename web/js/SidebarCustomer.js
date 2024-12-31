document.addEventListener("DOMContentLoaded", () => {
    // Load Sidebar Content
    fetch('../Customer/SidebarCustomer.jsp')
        .then(response => response.text())
        .then(data => {
            document.getElementById('sidebar').innerHTML = data;
        })
        .catch(error => console.error('Error loading sidebar:', error));
});