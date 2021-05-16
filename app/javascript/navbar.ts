// From https://bulma.io/documentation/components/navbar/#navbar-menu
export function start() {
  document.addEventListener("DOMContentLoaded", () => {
    const navbarBurgers: HTMLElement[] = Array.prototype.slice.call(
      document.querySelectorAll(".navbar-burger"),
      0
    );

    navbarBurgers.forEach(el => {
      el.addEventListener("click", () => {
        const target = document.getElementById(el.dataset.target);
        el.classList.toggle("is-active");
        target.classList.toggle("is-active");
      });
    });
  });
}
