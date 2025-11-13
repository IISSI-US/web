(function(){
  function ready(fn){ if(document.readyState !== 'loading'){ fn(); } else { document.addEventListener('DOMContentLoaded', fn); } }

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

  function ensureStructure(container){
    // If it's a legacy .sql-file, inject expected children structure
    if(container.classList.contains('sql-file')){
      container.classList.add('sql-embed');
      const label = document.createElement('div');
      label.className = 'sql-embed__header';
      label.innerHTML = '<span class="sql-embed__label"></span><button type="button" class="sql-embed__copy" aria-label="Copiar">Copiar</button>';
      const block = document.createElement('div');
      block.className = 'highlight';
      block.innerHTML = '<pre><code class="language-sql"></code></pre>';
      container.innerHTML = '';
      container.appendChild(label);
      container.appendChild(block);
    }
  }

  function normalizeSrc(src){
    if(!src) return src;
    if(src.indexOf('/silence-db/sql/') === 0){
      return src.replace('/silence-db/sql/', '/assets/sql/');
    }
    return src;
  }

  async function loadEmbed(container){
    ensureStructure(container);
    const rawSrc = container.getAttribute('data-src');
    const src = normalizeSrc(rawSrc);
    const codeEl = container.querySelector('pre code');
    const copyBtn = container.querySelector('.sql-embed__copy');
    const labelEl = container.querySelector('.sql-embed__label');
    if(labelEl && src){ labelEl.textContent = (container.getAttribute('data-label') || src).replace(/^\//,''); }
    if(!src || !codeEl) return;

    try{
      const res = await fetch(src, { cache: 'no-store' });
      if(!res.ok) throw new Error('HTTP '+res.status);
      const text = await res.text();
      codeEl.textContent = text; // preserve whitespace, no HTML injection
  if(copyBtn){ attachCopy(copyBtn, ()=>text); }
      // Optional: scroll to top of code
      codeEl.scrollTop = 0;
    }catch(err){
      console.error('SQL embed failed for', src, err);
      codeEl.textContent = '-- Error cargando '+src+': '+err;
      if(copyBtn){ copyBtn.disabled = true; }
    }
  }

  ready(function(){
    const blocks = document.querySelectorAll('.sql-embed[data-src], .sql-file[data-src]');
    blocks.forEach(loadEmbed);
  });
})();
