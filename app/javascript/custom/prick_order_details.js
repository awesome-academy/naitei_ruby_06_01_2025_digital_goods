function initializeDetailButtons() {
  document.querySelectorAll(".detail-btn").forEach((button) => {
    button.removeEventListener("click", toggleOrderDetail);
    button.addEventListener("click", toggleOrderDetail);
  });
}

function toggleOrderDetail() {
  const orderDetailContainer = document.querySelector(".orders-management__detail");
  if (orderDetailContainer) {
    orderDetailContainer.classList.toggle("active");
  }
}

function initializeCloseButton() {
  document.addEventListener("click", function (event) {
    if (event.target.closest(".icon-x")) {
      document.querySelector(".orders-management__detail")?.classList.remove("active");
    }
  });
}

document.addEventListener("turbo:load", function () {
  initializeDetailButtons();
  initializeCloseButton();
});

const observer = new MutationObserver(() => {
  initializeDetailButtons();
});

observer.observe(document.body, { childList: true, subtree: true });
