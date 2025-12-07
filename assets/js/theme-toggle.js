// Theme toggle functionality - restored original
(function () {
    'use strict';

    var STORAGE_KEY = 'mm-theme-mode'; // 'light' | 'dark' | 'auto'
    var mq = window.matchMedia('(prefers-color-scheme: dark)');

    function apply(mode) {
        var autoDark = mq.matches;
        var effective = mode === 'auto' ? (autoDark ? 'dark' : 'light') : mode;
        document.documentElement.setAttribute('data-theme', effective);
        updateIcon(mode);
    }

    function readMode() {
        try { return localStorage.getItem(STORAGE_KEY) || 'auto'; } catch (e) { return 'auto'; }
    }

    function writeMode(mode) {
        try { localStorage.setItem(STORAGE_KEY, mode); } catch (e) { }
    }

    function cycle() {
        var curr = readMode();
        var effective = curr === 'auto' ? (mq.matches ? 'dark' : 'light') : curr;
        var next = (curr === 'auto')
            ? (effective === 'dark' ? 'light' : 'dark')
            : (curr === 'dark' ? 'light' : 'auto');
        writeMode(next);
        apply(next);
    }

    function sunSVG() {
        return '<svg aria-hidden="true" viewBox="0 0 24 24" width="20" height="20" fill="currentColor"><path d="M6.76 4.84l-1.8-1.79-1.41 1.41 1.79 1.8 1.42-1.42zm10.48 14.32l1.79 1.8 1.41-1.41-1.8-1.79-1.4 1.4zM12 4V1h-0v3h0zm0 19v-3h0v3h0zM4 12H1v0h3v0zm19 0h-3v0h3v0zM6.76 19.16l-1.42 1.42-1.79-1.8 1.41-1.41 1.8 1.79zM20.45 4.46l-1.41-1.41-1.8 1.79 1.41 1.41 1.8-1.79zM12 6a6 6 0 100 12 6 6 0 000-12z"></path></svg>';
    }

    function moonSVG() {
        return '<svg aria-hidden="true" viewBox="0 0 24 24" width="20" height="20" fill="currentColor"><path d="M21 12.79A9 9 0 1111.21 3a7 7 0 109.79 9.79z"></path></svg>';
    }

    function updateIcon(mode) {
        var btn = document.getElementById('mm-theme-toggle');
        if (!btn) return;
        var autoDark = mq.matches;
        var effective = mode === 'auto' ? (autoDark ? 'dark' : 'light') : mode;
        btn.setAttribute('data-mode', mode);
        btn.title = 'Tema: ' + (mode === 'auto' ? ('auto (' + effective + ')') : mode);
        btn.setAttribute('aria-label', btn.title);
        btn.innerHTML = (effective === 'dark') ? moonSVG() : sunSVG();
    }

    function ensureToggleButton() {
        if (document.getElementById('mm-theme-toggle')) return;
        var btn = document.createElement('button');
        btn.id = 'mm-theme-toggle';
        btn.className = 'theme-toggle';
        btn.type = 'button';
        btn.addEventListener('click', cycle);
        document.body.appendChild(btn);
        updateIcon(readMode());
    }

    // Init
    document.addEventListener('DOMContentLoaded', function () {
        apply(readMode());
        ensureToggleButton();
    });

    mq.addEventListener('change', function () {
        if (readMode() === 'auto') apply('auto');
    });
})();


