// Get Modal element
var modal = document.getElementById("simpleModal");
// Get Open modal button
var modalBtn = document.getElementById("modalBtn");
// Get close modal button
var closeBtn = document.getElementsByClassName("closeBtn")[0];

// Listen for open/close click
modalBtn.addEventListener("click", openModal);
closeBtn.addEventListener("click", closeModal);
// Listen for outside click
window.addEventListener("click", outsideClick);

// Function to open modal
function openModal() {
  modal.style.display = "block";
}

function closeModal() {
  modal.style.display = "none";
}

function outsideClick(e) {
  if (e.target == modal) {
    modal.style.display = "none";
  }
}
