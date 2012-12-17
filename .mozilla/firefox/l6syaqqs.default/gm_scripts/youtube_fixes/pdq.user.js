// ==UserScript==
// @name            youtube fixes
// @description     Scroll to video, resize to fill and remove feedback button.
// @copyright       2012+, pdq
// @namespace       http://127.0.0.1
// @version         0.1
// @grant           none
// @include         http*://*.youtube.com/*
// @include         http*://youtube.com/*
// ==/UserScript==
(function () {
"use strict";

    function stylize() {
		var deleted = document.getElementById("yt-hitchhiker-feedback");
		deleted.parentNode.removeChild(deleted);

        /* document.body.style.background="#A7A7A7"; */

		return 1;
    }

    function moveVideo() {
        var video = document.getElementById("watch7-video-container");
 
        if (!video)
        	return 0;
 
        var body = document.body;
        body.insertBefore(video, body.firstChild);
  
        return 1;
    }
    
    function resizeVideo() {
        var video = document.getElementById("watch7-video-container");

        if (!video)
        	return 0;

        video.style.padding = "0";
        video.style.width   = "100%";
        video.style.height  = "100%";
 
        var videoWrapper = document.getElementById("watch7-video");

        if (!videoWrapper)
        	return 0;

        videoWrapper.style.width  = "100%";
        videoWrapper.style.height = "100%";

        var videoPlayer = document.getElementById("watch7-player");

        if (!videoPlayer)
        	return 0;

        videoPlayer.style.width  = "100%";
        videoPlayer.style.height = "100%";

        var sidebar = document.getElementById("watch7-sidebar");

        if (!sidebar)
        	return 0;

        // FF Fix (In firefox, the sidebar overlaps the video).
        sidebar.style.marginTop = "0"; // Webkit overrides the margin-top: -390px; while FF doesn't.

        return 1;
    }

    moveVideo();
    resizeVideo();
	stylize();    
})();
