document.addEventListener('turbo:load', initializeFilterContainers);
document.addEventListener('turbo:render', () => setTimeout(initializeFilterContainers, 50));

function initializeFilterContainers() {
  const filterContainers = document.querySelectorAll('.filter-container');

  filterContainers.forEach(container => {
    const listCategories = container.querySelector('.list-categories');

    if (!listCategories) return;

    container.removeEventListener('click', toggleFilter);
    container.addEventListener('click', toggleFilter);
    
    const selectItems = container.querySelectorAll('.item-category');
    selectItems.forEach(item => {
      item.removeEventListener('click', updateTextField);
      item.addEventListener('click', updateTextField);
    });
  });

  document.removeEventListener('click', closeDropdown);
  document.addEventListener('click', closeDropdown);
}

function toggleFilter(event) {
  event.stopPropagation();
  const container = event.currentTarget;
  const listCategories = container.querySelector('.list-categories');

  if (listCategories) {
    listCategories.classList.toggle('active');
  }
}

function updateTextField(event) {
  const selectedText = event.target.value;
  const container = event.target.closest('.filter-container');
  const textField = container.querySelector('.text_field');
  if (textField) {
    textField.textContent = selectedText;
  }
  closeDropdown(event)
}

function closeDropdown(event) {
  document.querySelectorAll('.filter-container').forEach(container => {
    if (!container.contains(event.target)) {
      const listCategories = container.querySelector('.list-categories');
      if (listCategories) listCategories.classList.remove('active');
    }
  });
}

const observer = new MutationObserver(() => {
  initializeFilterContainers();
});

observer.observe(document.body, { childList: true, subtree: true });
