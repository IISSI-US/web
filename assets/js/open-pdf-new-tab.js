document.addEventListener("DOMContentLoaded", () => {
  const links = document.querySelectorAll("a[href]");

  links.forEach((link) => {
    const href = link.getAttribute("href") || "";
    if (/\.pdf([?#].*)?$/i.test(href)) {
      link.target = "_blank";
      link.rel = "noopener noreferrer";
    }
  });
});
