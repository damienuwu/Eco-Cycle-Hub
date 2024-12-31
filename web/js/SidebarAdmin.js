document.addEventListener("DOMContentLoaded", () => {
    // Load Sidebar Content
    fetch('../Admin/SidebarAdmin.jsp')
        .then(response => response.text())
        .then(data => {
            document.getElementById('sidebar').innerHTML = data;
        })
        .catch(error => console.error('Error loading sidebar:', error));
});