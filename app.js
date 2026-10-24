'use strict';
// Keep the reflection concise on small screens while preserving native keyboard access.
document.querySelectorAll('.questions details').forEach((item) => {
  item.addEventListener('toggle', () => {
    if (!item.open) return;
    document.querySelectorAll('.questions details').forEach((other) => {
      if (other !== item) other.open = false;
    });
  });
});
