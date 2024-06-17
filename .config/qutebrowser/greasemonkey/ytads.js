// ==UserScript==
// u/name Skip YouTube ads
// u/description Skips the ads in YouTube videos
// u/run-at document-start
// u/match        *://*.youtube.com/*
// u/exclude      *://*.youtube.com/subscribe_embed?*
// ==/UserScript==

document.addEventListener('load', () => {
    const btn = document.querySelector('.videoAdUiSkipButton,.ytp-ad-skip-button-modern')
    if (btn) {
        btn.click()
    }
    const ad = [...document.querySelectorAll('.ad-showing')][0];
    if (ad) {
        document.querySelector('video').currentTime = 9999999999;
    }
}, true);
