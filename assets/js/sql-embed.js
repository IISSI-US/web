(function(){
  function ready(fn){ if(document.readyState !== 'loading'){ fn(); } else { document.addEventListener('DOMContentLoaded', fn); } }

  function highlightSQL(code){
    // Escape HTML
    code = code.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;');
    
    // Regex patterns for comments and strings
    const patterns = [
      { type: 'comment', regex: /--[^\n]*/g },
      { type: 'comment', regex: /\/\*[\s\S]*?\*\//g },
      { type: 'string', regex: /'(?:[^'\\]|\\.)*'/g },
      { type: 'string', regex: /"(?:[^"\\]|\\.)*"/g }
    ];
    
    // Find all comments and strings
    const protected = [];
    patterns.forEach(pattern => {
      let match;
      pattern.regex.lastIndex = 0;
      while((match = pattern.regex.exec(code)) !== null){
        protected.push({ start: match.index, end: match.index + match[0].length, type: pattern.type, text: match[0] });
      }
    });
    protected.sort((a, b) => a.start - b.start);
    
    // Build result with highlighted keywords
    let result = '';
    let lastPos = 0;
    
    protected.forEach(p => {
      // Process text before protected region
      if(lastPos < p.start){
        result += highlightKeywords(code.substring(lastPos, p.start));
      }
      // Add protected region with its highlighting
      result += `<span class="${p.type === 'comment' ? 'c' : 's'}">${p.text}</span>`;
      lastPos = p.end;
    });
    
    // Process remaining text
    if(lastPos < code.length){
      result += highlightKeywords(code.substring(lastPos));
    }
    
    return result;
  }
  
  function highlightKeywords(text){
    const keywords = /\b(SELECT|FROM|WHERE|INSERT|UPDATE|DELETE|CREATE|DROP|ALTER|TABLE|DATABASE|INDEX|VIEW|JOIN|LEFT|RIGHT|INNER|OUTER|ON|AS|AND|OR|NOT|NULL|IS|IN|BETWEEN|LIKE|ORDER|BY|GROUP|HAVING|LIMIT|OFFSET|SET|VALUES|INTO|PRIMARY|KEY|FOREIGN|REFERENCES|CONSTRAINT|CHECK|DEFAULT|AUTO_INCREMENT|UNIQUE|IF|EXISTS|USE|SHOW|DESCRIBE|INT|VARCHAR|TEXT|DATE|DATETIME|TIMESTAMP|BOOLEAN|ENUM|TINYINT|DECIMAL|FLOAT|DOUBLE)\b/gi;
    const numbers = /\b(\d+)\b/g;
    
    text = text.replace(keywords, '<span class="k">$1</span>');
    text = text.replace(numbers, '<span class="m">$1</span>');
    
    return text;
  }

  function attachCopy(btn, getText){
    btn.addEventListener('click', async function(){
      try{
        const text = getText();
        await navigator.clipboard.writeText(text);
        const original = btn.textContent;
        btn.textContent = 'Copiado!';
        btn.disabled = true;
        setTimeout(()=>{ btn.textContent = original; btn.disabled = false; }, 1200);
      }catch(e){
        console.error('Copy failed', e);
      }
    });
  }

  function attachToggle(container){
    const btn = container.querySelector('.sql-embed__toggle');
    const header = container.querySelector('.sql-embed__header');
    if(!btn || !header) return;
    function setState(collapsed){
      container.classList.toggle('is-collapsed', !!collapsed);
      btn.setAttribute('aria-expanded', collapsed ? 'false' : 'true');
    }
    function toggle(){ setState(!container.classList.contains('is-collapsed')); }
    btn.addEventListener('click', function(e){ e.stopPropagation(); toggle(); });
    // Make the whole header clickable except the copy button
    header.addEventListener('click', function(e){
      if(e.target && e.target.closest && e.target.closest('.sql-embed__copy')) return;
      toggle();
    });
  }

  function ensureStructure(container){
    // If it's a legacy .sql-file, inject expected children structure
    if(container.classList.contains('sql-file')){
      container.classList.add('sql-embed');
      const header = document.createElement('div');
      header.className = 'sql-embed__header';
      header.innerHTML = '<button type="button" class="sql-embed__toggle" aria-expanded="true" aria-label="Plegar/Desplegar"></button>'+
                         '<span class="sql-embed__label"></span>'+
                         '<button type="button" class="sql-embed__copy" aria-label="Copiar">Copiar</button>';
      const block = document.createElement('div');
      block.className = 'highlight';
      block.innerHTML = '<pre><code class="language-sql"></code></pre>';
      container.innerHTML = '';
      container.appendChild(header);
      container.appendChild(block);
    }
  }

  async function loadEmbed(container){
    ensureStructure(container);
    const src = container.getAttribute('data-src');
    const codeEl = container.querySelector('pre code');
    const copyBtn = container.querySelector('.sql-embed__copy');
    const labelEl = container.querySelector('.sql-embed__label');
    if(labelEl && src){ labelEl.textContent = (container.getAttribute('data-label') || src).replace(/^\//,''); }
    if(!src || !codeEl) return;

    try{
      const res = await fetch(src, { cache: 'no-store' });
      if(!res.ok) throw new Error('HTTP '+res.status);
      const text = await res.text();
      
      // Apply syntax highlighting and set innerHTML
      codeEl.innerHTML = highlightSQL(text);
      
      if(copyBtn){ attachCopy(copyBtn, ()=>text); }
      codeEl.scrollTop = 0;
    }catch(err){
      console.error('SQL embed failed for', src, err);
      codeEl.textContent = '-- Error cargando '+src+': '+err;
      if(copyBtn){ copyBtn.disabled = true; }
    }
    attachToggle(container);
  }

  ready(function(){
    const blocks = document.querySelectorAll('.sql-embed[data-src], .sql-file[data-src]');
    blocks.forEach(loadEmbed);
  });
})();
