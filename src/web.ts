import { WebPlugin } from '@capacitor/core';
import type { AgoraPlugin } from './definitions';

export class AgoraWeb extends WebPlugin implements AgoraPlugin {
  private client: any;
  private localVideoTrack: any;
  private localAudioTrack: any;
  private appId: string | null = null;

  async initialize(options: { appId: string }): Promise<void> {
    console.log('[AgoraWeb] initialize called with options:', options);

    const AgoraRTC = (window as any).AgoraRTC;
    if (!AgoraRTC) {
      throw new Error('[AgoraWeb] AgoraRTC is not available. Ensure you included the AgoraRTC script.');
    }

    if (!options.appId) {
      throw new Error('App ID is required');
    }

    this.appId = options.appId;

    // Création d'un client Agora avec la configuration recommandée
    this.client = AgoraRTC.createClient({ mode: 'rtc', codec: 'vp8' });
    console.log('[AgoraWeb] AgoraRTC client created');
  }

  async setupLocalVideo(): Promise<void> {
    console.log('[AgoraWeb] setupLocalVideo called');

    const AgoraRTC = (window as any).AgoraRTC;
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
        encoderConfig: 'high_quality' // Résolution maximale pour la vidéo
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
    } catch (error) {
      console.error('[AgoraWeb] Error in setupLocalVideo:', error);
      throw error;
    }
  }

  async joinChannel(options: { channelName: string; token: string | null; uid: number }): Promise<void> {
    console.log('[AgoraWeb] joinChannel called with options:', options);

    if (!this.client) {
      throw new Error('[AgoraWeb] Client is not initialized. Call initialize() first.');
    }

    if (!this.appId) {
      throw new Error('App ID is not initialized. Call initialize() first.');
    }

    await this.client.setClientRole('host');
    console.log('[AgoraWeb] Client role set to host.');

    await this.client.join(this.appId, options.channelName, options.token, options.uid);
    console.log('[AgoraWeb] Joined channel:', options.channelName);

    if (this.localAudioTrack && this.localVideoTrack) {
      await this.client.publish([this.localAudioTrack, this.localVideoTrack]);
      console.log('[AgoraWeb] Local audio and video tracks published');
    }
  }

  async switchCamera(): Promise<void> {
    console.log('[AgoraWeb] switchCamera called');

    if (this.localVideoTrack && typeof this.localVideoTrack.switchDevice === 'function') {
      const devices = await (window as any).AgoraRTC.getCameras();
      if (devices.length > 1) {
        await this.localVideoTrack.switchDevice(devices[1].deviceId);
        console.log('[AgoraWeb] Switched camera');
      } else {
        console.warn('[AgoraWeb] No alternative camera available');
      }
    } else {
      console.error('[AgoraWeb] switchCamera is not supported or localVideoTrack is not initialized');
    }
  }

  async leaveChannel(): Promise<void> {
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

  async enableWebViewTransparency(): Promise<void> {
    console.log('[AgoraWeb] enableWebViewTransparency called');
    throw this.unimplemented('[AgoraWeb] enableWebViewTransparency is not implemented on the web.');
  }

  async disableWebViewTransparency(): Promise<void> {
    console.log('[AgoraWeb] disableWebViewTransparency called');
    throw this.unimplemented('[AgoraWeb] disableWebViewTransparency is not implemented on the web.');
  }
}
