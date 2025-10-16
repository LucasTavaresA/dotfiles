// ==UserScript==
// u/name        youtube better theater mode
// u/description Set the default viewing mode to Theater Mode, and take the whole screen.
// u/run-at      document-start
// u/match        *://*.youtube.com/*
// u/exclude      *://*.youtube.com/subscribe_embed?*
// ==/UserScript==

const suggestBoxToDarkCSS = document.createElement('style');
suggestBoxToDarkCSS.innerText = `
[dark] {color-scheme: dark;}`.replaceAll(';', '!important;')

const fullscreenVideoCSS = document.createElement('style');
fullscreenVideoCSS.innerText = `
ytd-app:not([guide-persistent-and-visible]) [theater] #player video,
:is(ytd-watch-flexy[theater],ytd-watch-flexy[fullscreen]) #full-bleed-container {
height: 100vh; max-height: 100vh; min-height: 100vh;}`.replaceAll(';', '!important;')

const autoHideTopCSS = document.createElement('style');
autoHideTopCSS.innerText = `
#masthead-container.ytd-app:hover, #masthead-container.ytd-app:focus-within {width:100%;}
#masthead-container.ytd-app,
#masthead-container.ytd-app:not(:hover):not(:focus-within) {width:calc(50% - 150px);}
#masthead-container.ytd-app:not(:hover):not(:focus-within) {transition:width 0.4s ease-out 0.4s;}
ytd-app:not([guide-persistent-and-visible]) :is(#masthead-container ytd-masthead, #masthead-container.ytd-app::after) {transform: translateY(-56px); transition: transform .1s .3s ease-out;}
ytd-app:not([guide-persistent-and-visible]) :is(#masthead-container:hover ytd-masthead, #masthead-container:hover.ytd-app::after, #masthead-container:focus-within ytd-masthead) {transform: translateY(0px);}
ytd-app:not([guide-persistent-and-visible]) ytd-page-manager {margin-top: 0;}`.replaceAll(';', '!important;')
autoHideTopCSS.className = "autoHideTopCSS";

function isWatchPage() {
  return !(document.URL.indexOf('watch') == -1)
};

function isTheaterMode() {
  let scrollbarWidth = window.innerWidth - document.querySelector('ytd-app').offsetWidth;
  let playerWidth = document.querySelector('#ytd-player')?.offsetWidth;
  let isWidePlayer = scrollbarWidth + playerWidth == window.innerWidth;
  return (isWatchPage() && isWidePlayer)
};

function alwaysTheaterMode() {
  let clickModeButtonRepeatly = setInterval(_ => {
    if (isTheaterMode()) {
      clearInterval(clickModeButtonRepeatly);
    } else {
      document.querySelectorAll('.ytp-size-button')?.forEach(e => e.click());
      clearInterval(clickModeButtonRepeatly);
    }
  }, 250);
  setTimeout(_ => {
    clearInterval(clickModeButtonRepeatly);
  }, 10000);
};

window.addEventListener("yt-navigate-finish", function (event) {
  var timer = setInterval(function () {
    var newPlayer = document.querySelector('button.ytp-size-button')
    if (newPlayer && document.querySelector("video").clientWidth < document.body.clientWidth * 0.9) {
      // create a new keyboard event for 't'
      const event = new KeyboardEvent('keydown', {
        key: 't',
        code: 'KeyT',
        charCode: '116',
        keyCode: '84',
        which: '84'
      });

      // dispatch the event to the document object
      document.dispatchEvent(event);
      clearInterval(timer);
    } else if (newPlayer && document.querySelector("video")) {
      clearInterval(timer);
    }
  }, 250);

  ['yt-navigate-finish', 'load', 'unload', 'locationchange'].forEach(e => {
    window.addEventListener(e, _ => {
      isWatchPage() ? document.head.appendChild(autoHideTopCSS) : false;
      document.head.appendChild(suggestBoxToDarkCSS);
      document.head.appendChild(fullscreenVideoCSS);
      alwaysTheaterMode();
      window.scrollTo(0, 0);
    });
  });

  window.addEventListener('click', _ => {
    setTimeout(_ => {
      if (!isWatchPage() || !isTheaterMode()) {
        document.querySelector('.autoHideTopCSS')?.remove()
      } else if (isTheaterMode()) {
        document.head.appendChild(autoHideTopCSS)
      }
    }, 250);
  });
}, true);
