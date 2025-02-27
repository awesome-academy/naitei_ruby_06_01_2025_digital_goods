document.addEventListener('turbo:load', function() {
  let account = document.querySelector('#account');
  account.addEventListener('click', function(event) {
    event.stopPropagation();
    let menu = document.querySelector('#account-menu');
    menu.classList.toggle('active');
  });
});
