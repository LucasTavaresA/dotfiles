// ==UserScript==
// @name         youtube better theater mode
// @description  Set the default viewing mode to Theater Mode, and take the whole screen.
// @run-at       document-start
// @match        *://*.youtube.com/*
// @exclude      *://*.youtube.com/subscribe_embed?*
// @noframes
// ==/UserScript==

(function () {
    'use strict';

    const suggestBoxToDarkCSS = document.createElement('style');
    suggestBoxToDarkCSS.textContent = `
        [dark] {color-scheme: dark;}
    `.replaceAll(';', '!important;');

    const fullscreenVideoCSS = document.createElement('style');
    fullscreenVideoCSS.textContent = `
        ytd-app:not([guide-persistent-and-visible]) [theater] #player video,
        :is(ytd-watch-flexy[theater], ytd-watch-flexy[fullscreen]) #full-bleed-container {
            height: 100vh; max-height: 100vh; min-height: 100vh;
        }
    `.replaceAll(';', '!important;');

    const autoHideTopCSS = document.createElement('style');
    autoHideTopCSS.className = 'autoHideTopCSS';
    autoHideTopCSS.textContent = `
        #masthead-container.ytd-app:hover, #masthead-container.ytd-app:focus-within {width:100%;}
        #masthead-container.ytd-app,
        #masthead-container.ytd-app:not(:hover):not(:focus-within) {width:calc(50% - 150px);}
        #masthead-container.ytd-app:not(:hover):not(:focus-within) {transition:width 0.4s ease-out 0.4s;}
        ytd-app:not([guide-persistent-and-visible]) :is(#masthead-container ytd-masthead, #masthead-container.ytd-app::after) {transform: translateY(-56px); transition: transform .1s .3s ease-out;}
        ytd-app:not([guide-persistent-and-visible]) :is(#masthead-container:hover ytd-masthead, #masthead-container:hover.ytd-app::after, #masthead-container:focus-within ytd-masthead) {transform: translateY(0px);}
        ytd-app:not([guide-persistent-and-visible]) ytd-page-manager {margin-top: 0;}
    `.replaceAll(';', '!important;');

    let theaterTimer = null;

    function isWatchPage() {
        return window.location.pathname === '/watch';
    }

    function isTheaterMode() {
        return document.querySelector('ytd-watch-flexy[theater]') !== null;
    }

    function appendStyle(style) {
        const styleParent = document.head ?? document.documentElement;

        if (styleParent !== null && style.parentNode !== styleParent) {
            styleParent.appendChild(style);
        }
    }

    function applyStyles() {
        appendStyle(suggestBoxToDarkCSS);
        appendStyle(fullscreenVideoCSS);

        if (isWatchPage()) {
            appendStyle(autoHideTopCSS);
        } else {
            autoHideTopCSS.remove();
        }
    }

    function stopTheaterTimer() {
        if (theaterTimer === null) return;

        window.clearInterval(theaterTimer);
        theaterTimer = null;
    }

    function alwaysTheaterMode() {
        stopTheaterTimer();

        if (!isWatchPage()) return;

        let attempts = 0;

        theaterTimer = window.setInterval(() => {
            attempts++;

            if (!isWatchPage() || isTheaterMode() || attempts >= 40) {
                stopTheaterTimer();
                return;
            }

            const sizeButton = document.querySelector('button.ytp-size-button');

            if (sizeButton !== null) {
                sizeButton.click();
                stopTheaterTimer();
            }
        }, 250);
    }

    function handlePageUpdate() {
        applyStyles();
        alwaysTheaterMode();

        if (isWatchPage()) {
            window.scrollTo(0, 0);
        }
    }

    window.addEventListener('yt-navigate-finish', handlePageUpdate);
    window.addEventListener('load', handlePageUpdate);
    window.addEventListener('click', () => {
        window.setTimeout(applyStyles, 250);
    });

    handlePageUpdate();
})();
