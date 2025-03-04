function initProductFormSteps() {
  const steps = document.querySelectorAll(".form-step");
  const trackingSteps = document.querySelectorAll(".tracking-step");
  const trackingLines = document.querySelectorAll(".tracking-line");
  const nextButton = document.querySelector(".continue-btn");
  const prevButton = document.querySelector(".cancel-btn");

  let currentStep = 0;

  function updateStepUI() {
    steps.forEach((step, i) => {
      step.style.display = i === currentStep ? "block" : "none";
    });

    trackingSteps.forEach((step, i) => {
      step.classList.toggle("active", i <= currentStep);
    });

    trackingLines.forEach((step, i) => {
      step.classList.toggle("active", i <= currentStep);
    });
  }

  nextButton.addEventListener("click", () => {
    if (currentStep < steps.length - 1) {
      currentStep++;
      updateStepUI();
    } else {
      document.querySelector(".form-input-product-info").submit();
    }
  });

  prevButton.addEventListener("click", () => {
    if (currentStep > 0) {
      currentStep--;
      updateStepUI();
    }
  });

  updateStepUI();
}

document.addEventListener("turbo:load", initProductFormSteps);
