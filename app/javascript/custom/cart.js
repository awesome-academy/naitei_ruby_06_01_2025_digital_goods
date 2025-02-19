function updateTotal() {
  let checkboxes = document.querySelectorAll('.product-checkbox');
  let totalPriceElement = document.querySelector('#total-price');
  let total = 0;
  let hiddenInput = document.querySelector('#checked-cart-items');
  let checkedItems = [];

  checkboxes.forEach(checkbox => {
    if (checkbox.checked) {
      let price = parseFloat(checkbox.dataset.price);
      let quantity = parseInt(checkbox.dataset.quantity);
      total += price * quantity;
      checkedItems.push(checkbox.dataset.id);
    }
  });

  if (totalPriceElement) {
    totalPriceElement.innerText = total.toLocaleString("vi-VN") + " đ";
  }
  hiddenInput.value = checkedItems.join(',');
}

window.updateTotal = updateTotal;

document.addEventListener('turbo:load', function() {
  let checkboxes = document.querySelectorAll('.product-checkbox');
  checkboxes.forEach(checkbox => {
    checkbox.addEventListener('change', updateTotal);
  });

  updateTotal();
});
