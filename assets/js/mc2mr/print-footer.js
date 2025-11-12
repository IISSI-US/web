// Add print footer with current date and author
document.addEventListener('DOMContentLoaded', function() {
  // Set the generated date for print footer
  const now = new Date();
  const dateStr = now.toLocaleDateString('es-ES', { 
    year: 'numeric', 
    month: 'long', 
    day: 'numeric' 
  });
  const timeStr = now.toLocaleTimeString('es-ES', { 
    hour: '2-digit', 
    minute: '2-digit' 
  });
  
  document.body.setAttribute('data-generated-date', `${dateStr} a las ${timeStr}`);
  
  // Add print-specific styles when printing
  window.addEventListener('beforeprint', function() {
    // Update footer content right before printing
    const currentDate = new Date().toLocaleDateString('es-ES', { 
      year: 'numeric', 
      month: 'long', 
      day: 'numeric' 
    });
    const currentTime = new Date().toLocaleTimeString('es-ES', { 
      hour: '2-digit', 
      minute: '2-digit' 
    });
    
    document.body.setAttribute('data-generated-date', `${currentDate} a las ${currentTime}`);
  });
});