// ==UserScript==
// @name         SoundCloud Media Feed Tracker
// @version      3.0.0
// @author       LucasTavaresA
// @license      GPL-3.0-or-later
// @namespace    https://gist.github.com/LucasTavaresA/51b9a4b36dd7070f96abddf7948dae94
// @description  Shows played songs on your soundcloud feed, saves a history with their information, SCTracker.* has export and many other utility functions.
// @grant        unsafeWindow
// @match        *://soundcloud.com/*
// @run-at       document-end
// @noframes
// ==/UserScript==

// @ts-check
(function () {
    'use strict';

    /**
     * Live playback observation before it is written to IndexedDB.
     *
     * @typedef {{
     *   title: string,
     *   artist: string,
     *   url: string,
     *   timestamp: string
     * }} TrackInfo
     */

    /**
     * Persisted IndexedDB record.
     *
     * @typedef {{
     *   title: string,
     *   artist: string,
     *   url: string,
     *   firstPlayed: string,
     *   lastPlayed: string,
     *   playCount: number
     * }} StoredTrack
     */

    const STORE_NAME = 'tracks';
    const MARK_CLASS = 'sc-played-track';
    let db = null;
    let historyPromise = null;
    let setupPromise = null;
    let lastTrackUrl = null;
    let playedUrlsSet = new Set();
    let trackerHalted = false;
    let playbackObserver = null;
    let feedObserver = null;

    /** @type {(ms: number) => Promise<void>} */
    const wait = (ms) => new Promise(resolve => window.setTimeout(resolve, ms));

    /** @type (message: string, details?: any) => void */
    function haltTracker(message, details = null) {
        if (trackerHalted) return;

        trackerHalted = true;
        playbackObserver?.disconnect();
        feedObserver?.disconnect();

        console.error(message, details);
        window.alert(message);
    }

    /** @type (url: string) => string */
    function normalizeUrl(url) {
        try {
            const urlObj = new URL(url);

            return urlObj.origin + urlObj.pathname;
        } catch (e) {
            console.warn(`SC Tracker: Error normalizing URL '${url}':`, e);
            return url;
        }
    }

    function openDB() {
        const DB_SCHEMA_VERSION = 1;
        return new Promise((resolve, reject) => {
            const req = indexedDB.open('soundcloud_tracker', DB_SCHEMA_VERSION);

            req.onupgradeneeded = e => {
                const db = req.result;

                if (e.oldVersion < 1) {
                    const store = db.createObjectStore(
                        STORE_NAME,
                        { keyPath: 'url' }
                    );

                    store.createIndex('title', 'title');
                    store.createIndex('artist', 'artist');
                }
            };
            req.onsuccess = () => resolve(req.result);
            req.onerror = () => reject(req.error);
        });
    }

    /** @type {() => Promise<StoredTrack[]>} */
    async function getAllTracks() {
        await loadHistory();

        return new Promise((resolve, reject) => {
            const tx = db.transaction(STORE_NAME, 'readonly');
            const req = tx.objectStore(STORE_NAME).getAll();
            req.onsuccess = () => resolve(req.result);
            req.onerror = () => reject(req.error);
        });
    }

    function getAllPlayedUrls() {
        return new Promise((resolve, reject) => {
            const tx = db.transaction(STORE_NAME, 'readonly');
            const req = tx.objectStore(STORE_NAME).getAllKeys();
            req.onsuccess = () => resolve(req.result);
            req.onerror = () => reject(req.error);
        });
    }

    /** @type (track: TrackInfo) => Promise<void> */
    function putTrack(track) {
        return new Promise((resolve, reject) => {
            const tx = db.transaction(STORE_NAME, 'readwrite');
            const store = tx.objectStore(STORE_NAME);
            const getReq = store.get(track.url);

            getReq.onsuccess = () => {
                const existing = getReq.result;

                if (existing !== undefined) {
                    existing.lastPlayed =
                        new Date().toISOString();

                    existing.playCount = (existing.playCount ?? 1) + 1;

                    store.put(existing);
                } else {
                    store.put({
                        title: track.title,
                        artist: track.artist,
                        url: track.url,
                        firstPlayed: track.timestamp,
                        lastPlayed: track.timestamp,
                        playCount: 1
                    });
                }
            };
            getReq.onerror = () => reject(getReq.error);

            tx.oncomplete = () => resolve();
            tx.onerror = () => reject(tx.error);
        });
    }

    async function exportSongs() {
        const tracks = await getAllTracks();
        if (tracks.length === 0) {
            console.warn('SC Tracker: No tracks to export');
            return;
        }
        const blob = new Blob([JSON.stringify(tracks, null, 2)], { type: 'application/json' });
        const url = URL.createObjectURL(blob);
        const a = document.createElement('a');
        a.href = url;
        a.download = 'sc-tracks.json';

        document.body.appendChild(a);
        a.click();
        document.body.removeChild(a);

        void wait(1000).then(() => URL.revokeObjectURL(url));
    }

    async function migrateFromLocalStorage() {
        const raw = localStorage.getItem('soundcloud_track_history');
        if (!raw) {
            return;
        }

        try {
            const tracks = JSON.parse(raw);
            const tx = db.transaction(STORE_NAME, 'readwrite');
            const store = tx.objectStore(STORE_NAME);

            for (const t of tracks) {
                store.put(t);
            }

            await new Promise((res, rej) => { tx.oncomplete = res; tx.onerror = rej; });
            localStorage.removeItem('soundcloud_track_history');
            console.log(`SC Tracker: Migrated ${tracks.length} tracks from localStorage and cleared it ✅`);
        } catch (e) {
            console.error('SC Tracker: LocalStorage migration failed:', e);
        }
    }

    function loadHistory() {
        if (historyPromise === null) {
            historyPromise = (async () => {
                db = await openDB();
                await migrateFromLocalStorage();
                const urls = await getAllPlayedUrls();
                playedUrlsSet = new Set(urls);
                console.log(`SC Tracker: 📚 Loaded ${urls.length} tracks from history`);
            })().catch(e => {
                historyPromise = null;
                throw e;
            });
        }

        return historyPromise;
    }

    /** @type (root?: HTMLElement | null) => void */
    function markPlayedTracks(root = null) {
        if (root === null) {
            root = document.querySelector('.lazyLoadingList__list');
            if (root === null) return;
        }

        if (
            root instanceof HTMLAnchorElement
            && (root.classList.contains('soundTitle__title') || root.classList.contains('trackItem__trackTitle'))
            && playedUrlsSet.has(normalizeUrl(root.href))
        ) {
            root.classList.add(MARK_CLASS);
        }

        /** @type {NodeListOf<HTMLAnchorElement>} */
        const links = root.querySelectorAll('a.soundTitle__title, a.trackItem__trackTitle');

        links.forEach(link => {
            if (playedUrlsSet.has(normalizeUrl(link.href))) {
                link.classList.add(MARK_CLASS);
            }
        });
    }

    /** @returns {TrackInfo | null} */
    function getTrackInfo() {
        /** @type {HTMLAnchorElement | null} */
        const trackAnchor = document.querySelector('.playbackSoundBadge__titleLink');

        if (!trackAnchor?.href) {
            return null;
        }

        const artistElem = document.querySelector('.playbackSoundBadge__lightLink');

        return {
            title: trackAnchor.getAttribute('title')?.trim()
                || trackAnchor.textContent?.trim()
                || 'Unknown',
            artist: artistElem?.textContent?.trim() || 'Unknown',
            url: normalizeUrl(trackAnchor.href),
            timestamp: new Date().toISOString()
        };
    }

    let trackChangeLock = Promise.resolve();
    function trackChanged() {
        if (trackerHalted) return;

        trackChangeLock = trackChangeLock.then(async () => {
            if (trackerHalted) return;

            const info = getTrackInfo();

            if (!info) {
                return;
            }

            if (lastTrackUrl === null) {
                lastTrackUrl = info.url;
                return;
            }

            if (info.url === lastTrackUrl) {
                return;
            }

            await putTrack(info);

            lastTrackUrl = info.url;
            playedUrlsSet.add(info.url);
            markPlayedTracks();
        })
            .catch(e => console.error('SC Tracker: trackChanged error:', e));
    }

    async function setupTracker() {
        /** @type {Element | null} */
        let playbackBar = null;

        for (let attempt = 1; attempt <= 10; attempt++) {
            playbackBar = document.querySelector('.playControls__soundBadge');

            if (playbackBar !== null) {
                break;
            }

            if (attempt < 10) {
                await wait(1000);
            }
        }

        if (playbackBar === null) {
            console.error("SC Tracker: your browser couldn't load the playback bar");
            return;
        }

        await loadHistory();
        markPlayedTracks();

        const currentPlaybackBar = document.querySelector('.playControls__soundBadge');

        if (currentPlaybackBar === null) {
            haltTracker('SC Tracker: playback bar disappeared during setup; tracker stopped.');
            return;
        }

        playbackObserver = new MutationObserver(trackChanged);

        playbackObserver.observe(currentPlaybackBar, {
            childList: true,
            subtree: true,
            attributes: true,
            attributeFilter: ['href', 'title']
        });

        feedObserver = new MutationObserver(mutations => {
            if (trackerHalted) return;

            for (const mutation of mutations) {
                mutation.addedNodes.forEach(node => {
                    if (node instanceof HTMLElement) {
                        markPlayedTracks(node);
                    }
                });
            }
        });
        const feed = document.querySelector('.lazyLoadingList__list') ?? document.body;

        feedObserver.observe(feed, {
            childList: true,
            subtree: true
        });
    }

    function startTracker() {
        if (setupPromise === null) {
            setupPromise = setupTracker().catch(e => {
                setupPromise = null;
                console.error('SC Tracker: setup failed:', e);
            });
        }
    }

    /** @type (n: number) => void */
    function topPosters(n) {
        const counts = {};

        document.querySelectorAll('.soundContext__usernameLink').forEach(el => {
            const name = el.textContent.trim();
            counts[name] = (counts[name] ?? 0) + 1;
        });

        console.table(
            Object.entries(counts)
                .sort((a, b) => b[1] - a[1])
                .slice(0, n)
                .map(([name, count]) => ({ name, count }))
        );
    }

    /** @type (n: number) => Promise<void> */
    async function topArtists(n) {
        const tracks = await getAllTracks();

        const counts = {};

        for (const track of tracks) {
            counts[track.artist] =
                (counts[track.artist] ?? 0) +
                (track.playCount ?? 1);
        }

        console.table(
            Object.entries(counts)
                .sort((a, b) => b[1] - a[1])
                .slice(0, n)
                .map(([artist, count]) => ({ artist, count }))
        );
    }

    /** @type (n: number) => Promise<void> */
    async function topTracks(n) {
        const tracks = await getAllTracks();

        console.table(
            tracks
                .sort(
                    (a, b) =>
                        (b.playCount ?? 1) -
                        (a.playCount ?? 1)
                )
                .slice(0, n)
                .map(
                    track => ({
                        artist: track.artist,
                        title: track.title,
                        plays: track.playCount ?? 1
                    }))
        );
    }

    /** @type (n: number) => Promise<void> */
    async function recentTracks(n) {
        const tracks = await getAllTracks();

        console.table(
            tracks
                .sort(
                    (a, b) =>
                        Date.parse(b.lastPlayed) - Date.parse(a.lastPlayed)
                )
                .slice(0, n).map(
                    track => ({
                        artist: track.artist,
                        title: track.title,
                        plays: track.playCount ?? 1,
                    }))
        );
    }

    if (window.location.href.startsWith("https://soundcloud.com/feed")) {
        const style = document.createElement('style');
        style.textContent = `
            a.${MARK_CLASS} {
                color: #f70 !important;
                text-decoration: underline !important;
            }
        `;
        document.head.appendChild(style);
    }

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', startTracker, { once: true });
    } else {
        startTracker();
    }

    unsafeWindow.SCTracker = {
        exportSongs,
        topArtists,
        topPosters,
        topTracks,
        recentTracks
    };
})();
