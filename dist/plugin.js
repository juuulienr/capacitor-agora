var capacitorAgora = (function (exports, core) {
    'use strict';

    const Agora = core.registerPlugin('Agora', {
        web: () => Promise.resolve().then(function () { return web; }).then((m) => new m.AgoraWeb()),
    });

    class AgoraWeb extends core.WebPlugin {
        constructor() {
            super(...arguments);
            this.appId = null;
        }
        async initialize(options) {
            console.log('[AgoraWeb] initialize called with options:', options);
            const AgoraRTC = window.AgoraRTC;
            if (!AgoraRTC) {
                throw new Error('[AgoraWeb] AgoraRTC is not available. Ensure you included the AgoraRTC script.');
            }
            if (!options.appId) {
                throw new Error('App ID is required');
            }
            this.appId = options.appId;
            // Création d'un client Agora avec la configuration recommandée
            this.client = AgoraRTC.createClient({ mode: 'live', codec: 'vp8' });
            console.log('[AgoraWeb] AgoraRTC client created');
        }
        async setupLocalVideo() {
            console.log('[AgoraWeb] setupLocalVideo called');
            const AgoraRTC = window.AgoraRTC;
            if (!AgoraRTC) {
                throw new Error('[AgoraWeb] AgoraRTC is not available.');
            }
            try {
                const livestreamContainer = document.querySelector('.livestream');
                if (!livestreamContainer) {
                    throw new Error('[AgoraWeb] No element found with class "livestream". Ensure it exists in the DOM.');
                }
                // Création des pistes vidéo et audio locales avec résolution maximale
                this.localVideoTrack = await AgoraRTC.createCameraVideoTrack({
                    encoderConfig: '1080p'
                });
                this.localAudioTrack = await AgoraRTC.createMicrophoneAudioTrack();
                console.log('[AgoraWeb] Local video and audio tracks created with high resolution');
                const videoContainer = document.createElement('div');
                videoContainer.id = 'local-video';
                videoContainer.style.width = '100%';
                videoContainer.style.height = '100%';
                livestreamContainer.appendChild(videoContainer);
                console.log('[AgoraWeb] Video container added to .livestream');
                this.localVideoTrack.play('local-video');
                console.log('[AgoraWeb] Local video track started');
            }
            catch (error) {
                console.error('[AgoraWeb] Error in setupLocalVideo:', error);
                throw error;
            }
        }
        async joinChannel(options) {
            console.log('[AgoraWeb] joinChannel called with options:', options);
            if (!this.client) {
                console.error('[AgoraWeb] Client is not initialized. Call initialize() first.');
                throw new Error('Client is not initialized. Call initialize() first.');
            }
            if (!this.appId) {
                console.error('[AgoraWeb] App ID is not initialized. Call initialize() first.');
                throw new Error('App ID is not initialized. Call initialize() first.');
            }
            console.log('[AgoraWeb] Debugging joinChannel variables:');
            console.log('App ID:', this.appId);
            console.log('Channel Name:', options.channelName);
            console.log('Token:', options.token);
            console.log('UID:', options.uid);
            await this.client.setClientRole('host');
            console.log('[AgoraWeb] Client role set to host.');
            try {
                await this.client.join(this.appId, options.channelName, options.token, options.uid);
                console.log('[AgoraWeb] Successfully joined channel:', options.channelName);
                if (this.localAudioTrack && this.localVideoTrack) {
                    await this.client.publish([this.localAudioTrack, this.localVideoTrack]);
                    console.log('[AgoraWeb] Local audio and video tracks published');
                }
            }
            catch (error) {
                console.error('[AgoraWeb] Error while joining channel:', error);
                throw error;
            }
        }
        async switchCamera() {
            console.log('[AgoraWeb] switchCamera called');
            if (this.localVideoTrack && typeof this.localVideoTrack.switchDevice === 'function') {
                const devices = await window.AgoraRTC.getCameras();
                if (devices.length > 1) {
                    await this.localVideoTrack.switchDevice(devices[1].deviceId);
                    console.log('[AgoraWeb] Switched camera');
                }
                else {
                    console.warn('[AgoraWeb] No alternative camera available');
                }
            }
            else {
                console.error('[AgoraWeb] switchCamera is not supported or localVideoTrack is not initialized');
            }
        }
        async leaveChannel() {
            console.log('[AgoraWeb] leaveChannel called');
            if (!this.client) {
                throw new Error('[AgoraWeb] Client is not initialized.');
            }
            if (this.localVideoTrack) {
                this.localVideoTrack.stop();
                this.localVideoTrack.close();
            }
            if (this.localAudioTrack) {
                this.localAudioTrack.stop();
                this.localAudioTrack.close();
            }
            await this.client.leave();
            console.log('[AgoraWeb] Left channel');
        }
        async enableWebViewTransparency() {
            console.log('[AgoraWeb] enableWebViewTransparency called');
            throw this.unimplemented('[AgoraWeb] enableWebViewTransparency is not implemented on the web.');
        }
        async disableWebViewTransparency() {
            console.log('[AgoraWeb] disableWebViewTransparency called');
            throw this.unimplemented('[AgoraWeb] disableWebViewTransparency is not implemented on the web.');
        }
    }

    var web = /*#__PURE__*/Object.freeze({
        __proto__: null,
        AgoraWeb: AgoraWeb
    });

    exports.Agora = Agora;

    return exports;

})({}, capacitorExports);
//# sourceMappingURL=plugin.js.map
