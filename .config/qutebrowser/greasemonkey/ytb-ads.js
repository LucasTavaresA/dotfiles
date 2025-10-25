// ==UserScript==
// u/name         Auto Skip YouTube Ads
// u/version      7.3.0
// u/description  Automatically skip YouTube ads instantly. Undetected by YouTube ad blocker warnings.
// u/author       tientq64
// u/match        *://*.youtube.com/*
// u/exclude      *://*.youtube.com/subscribe_embed?*
// u/exclude      https://studio.youtube.com/*
// ==/UserScript==

function skipAd() {
    if (checkIsYouTubeShorts()) return

    // This element appears when a video ad appears.
    const adShowing = document.querySelector('.ad-showing')

    // Timed pie countdown ad.
    const pieCountdown = document.querySelector('.ytp-ad-timed-pie-countdown-container')

    // Survey questions in video player.
    const surveyQuestions = document.querySelector('.ytp-ad-survey-questions')

    if (adShowing === null && pieCountdown === null && surveyQuestions === null) return

    const moviePlayerEl = document.querySelector('#movie_player')
    let playerEl
    let player

    if (isYouTubeMobile || isYouTubeMusic) {
        playerEl = moviePlayerEl
        player = playerEl
    } else {
        playerEl = document.querySelector('#ytd-player')
        player = playerEl && playerEl.getPlayer()
    }

    if (playerEl === null || player === null) {
        console.log({
            message: 'Player not found',
            timeStamp: getCurrentTimeString()
        })
        return
    }

    // ad.classList.remove('ad-showing')

    let adVideo = null

    if (pieCountdown === null && surveyQuestions === null) {
        adVideo = document.querySelector(
            '#ytd-player video.html5-main-video, #song-video video.html5-main-video'
        )

        console.table({
            message: 'Ad video',
            video: adVideo !== null,
            src: adVideo?.src,
            paused: adVideo?.paused,
            currentTime: adVideo?.currentTime,
            duration: adVideo?.duration,
            timeStamp: getCurrentTimeString()
        })

        if (adVideo !== null) {
            adVideo.muted = true
        }
        if (adVideo === null || !adVideo.src || adVideo.paused || isNaN(adVideo.duration)) {
            return
        }

        console.log({
            message: 'Ad video has finished loading',
            timeStamp: getCurrentTimeString()
        })
    }

    if (isYouTubeMusic && adVideo !== null) {
        adVideo.currentTime = adVideo.duration

        console.table({
            message: 'Ad skipped',
            timeStamp: getCurrentTimeString(),
            adShowing: adShowing !== null,
            pieCountdown: pieCountdown !== null,
            surveyQuestions: surveyQuestions !== null
        })
    } else {
        const videoData = player.getVideoData()
        const videoId = videoData.video_id
        const start = Math.floor(player.getCurrentTime())

        if (moviePlayerEl !== null && moviePlayerEl.isSubtitlesOn()) {
            window.setTimeout(moviePlayerEl.toggleSubtitlesOn, 1000)
        }

        if ('loadVideoWithPlayerVars' in playerEl) {
            playerEl.loadVideoWithPlayerVars({ videoId, start })
        } else {
            playerEl.loadVideoByPlayerVars({ videoId, start })
        }

        console.table({
            message: 'Ad skipped',
            videoId,
            start,
            title: videoData.title,
            timeStamp: getCurrentTimeString(),
            adShowing: adShowing !== null,
            pieCountdown: pieCountdown !== null,
            surveyQuestions: surveyQuestions !== null
        })
    }
}

function checkIsYouTubeShorts() {
    return location.pathname.startsWith('/shorts/')
}

function getCurrentTimeString() {
    return new Date().toTimeString().split(' ', 1)[0]
}

function addCss() {
    const adsSelectors = [
        // Ad banner in the upper right corner, above the video playlist.
        '#player-ads',
        '#panels > ytd-engagement-panel-section-list-renderer[target-id="engagement-panel-ads"]',

        // Masthead ad on home page.
        '#masthead-ad',

        // Sponsored ad video items on home page.
        // 'ytd-ad-slot-renderer',

        // '.ytp-suggested-action',
        '.yt-mealbar-promo-renderer',

        // Featured product ad banner at the bottom left of the video.
        '.ytp-featured-product',

        // Products shelf ad banner below the video description.
        'ytd-merch-shelf-renderer',

        // YouTube Music Premium trial promotion dialog, bottom left corner.
        'ytmusic-mealbar-promo-renderer',

        // YouTube Music Premium trial promotion banner on home page.
        'ytmusic-statement-banner-renderer'
    ]
    const adsSelector = adsSelectors.join(',')
    const css = `${adsSelector} { display: none !important; }`
    const style = document.createElement('style')
    style.textContent = css
    document.head.appendChild(style)
}

/**
 * Remove ad elements using JavaScript because these selectors require the use of the CSS
 * `:has` selector which is not supported in older browser versions.
 */
function removeAdElements() {
    const adSelectors = [
        // Sponsored ad video items on home page.
        // ['ytd-rich-item-renderer', '.ytd-ad-slot-renderer'],

        // ['ytd-rich-section-renderer', '.ytd-statement-banner-renderer'],

        // Ad videos on YouTube Shorts.
        ['ytd-reel-video-renderer', '.ytd-ad-slot-renderer']

        // Ad blocker warning dialog.
        // ['tp-yt-paper-dialog', '#feedback.ytd-enforcement-message-view-model'],

        // Survey dialog on home page, located at bottom right.
        // ['tp-yt-paper-dialog', ':scope > ytd-checkbox-survey-renderer'],

        // Survey to rate suggested content, located at bottom right.
        // ['tp-yt-paper-dialog', ':scope > ytd-single-option-survey-renderer']
    ]
    for (const adSelector of adSelectors) {
        const adEl = document.querySelector(adSelector[0])
        if (adEl === null) continue
        const neededEl = adEl.querySelector(adSelector[1])
        if (neededEl === null) continue
        adEl.remove()
    }
}

const isYouTubeMobile = location.hostname === 'm.youtube.com'
const isYouTubeDesktop = !isYouTubeMobile

const isYouTubeMusic = location.hostname === 'music.youtube.com'
const isYouTubeVideo = !isYouTubeMusic

addCss()

if (isYouTubeVideo) {
    window.setInterval(removeAdElements, 1000)
    removeAdElements()
}

window.setInterval(skipAd, 500)
skipAd()

// const observer = new MutationObserver(skipAd)
// observer.observe(document.body, {
// 	attributes: true,
// 	attributeFilter: ['class'],
// 	childList: true,
// 	subtree: true
// })
