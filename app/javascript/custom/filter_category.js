document.addEventListener('turbo:load', initializeFilterContainers);
document.addEventListener('turbo:render', () => setTimeout(initializeFilterContainers, 50));

function initializeFilterContainers() {
  const filterContainers = document.querySelectorAll('.filter-container');

  filterContainers.forEach(container => {
    const listCategories = container.querySelector('.list-categories');

    if (!listCategories) return;

    container.removeEventListener('click', toggleFilter);
    container.addEventListener('click', toggleFilter);
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
