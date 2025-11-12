// PlantUML renderer - usa PNGs existentes en exports/
document.addEventListener('DOMContentLoaded', function() {
    // Find all PlantUML code blocks
    const plantUMLBlocks = document.querySelectorAll('pre code.language-plantuml');
    
    plantUMLBlocks.forEach(function(block) {
        try {
            // Get the PlantUML source code to determine diagram type
            const plantUMLSource = block.textContent.trim();
            
            // Determine exercise number and diagram type from the current page
            const currentPath = window.location.pathname;
            const exerciseMatch = currentPath.match(/(\d+)_/);
            
            if (!exerciseMatch) return;
            
            const exerciseNumber = exerciseMatch[1].padStart(2, '0');
            
            // Determine if it's a class or object diagram
            const isObjectDiagram = plantUMLSource.includes('object ') || 
                                   plantUMLSource.includes('Object ') ||
                                   plantUMLSource.toLowerCase().includes('diagrama de objetos');
            
            const diagramType = isObjectDiagram ? 'objetos' : 'clases';
            
            // Map exercise numbers to names
            const exerciseNames = {
                '01': 'universidad',
                '02': 'biblioteca', 
                '03': 'herencia-completa-disjunta',
                '04': 'herencia-completa-solapada',
                '05': 'herencia-incompleta-disjunta',
                '06': 'herencia-incompleta-solapada',
                '07': 'clase-asociacion',
                '08': 'relaciones-mn',
                '09': 'torneo-tenis'
            };
            
            const exerciseName = exerciseNames[exerciseNumber];
            if (!exerciseName) return;
            
            // Build image path (images are under /mc2mr/ in this site)
            const imagePath = `/mc2mr/ejercicio-${exerciseNumber}-${exerciseName}-${diagramType}.png`;
            
            // Create container for the diagram
            const container = document.createElement('div');
            container.className = 'plantuml-diagram';
            container.style.textAlign = 'center';
            container.style.margin = '2rem 0';
            
            // Create image element
            const img = document.createElement('img');
            img.src = imagePath;
            img.alt = `Diagrama UML ${diagramType}`;
            img.style.maxWidth = '100%';
            img.style.height = 'auto';
            img.style.border = '1px solid var(--border-color)';
            img.style.borderRadius = '6px';
            img.style.boxShadow = '0 2px 8px rgba(0, 0, 0, 0.1)';
            img.style.backgroundColor = 'white';
            
            container.appendChild(img);
            
            // Replace the original code block with the image
            const parentPre = block.closest('pre');
            if (parentPre && parentPre.parentNode) {
                parentPre.parentNode.replaceChild(container, parentPre);
            }
            
        } catch (error) {
            console.error('Error processing PlantUML block:', error);
        }
    });
});