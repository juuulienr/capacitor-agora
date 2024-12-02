import { WebPlugin } from '@capacitor/core';
import type { AgoraPlugin } from './definitions';

export class AgoraWeb extends WebPlugin implements AgoraPlugin {
  private client: any;
  private localVideoTrack: any;
  private localAudioTrack: any;

  async initialize(options: { appId: string }): Promise<void> {
    console.log('[AgoraWeb] initialize called with options:', options);

    const AgoraRTC = (window as any).AgoraRTC;
    if (!AgoraRTC) {
      throw new Error('[AgoraWeb] AgoraRTC is not available. Ensure you included the AgoraRTC script.');
    }

    // Création d'un client Agora
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
      // Vérifie si l'élément avec la classe 'livestream' existe
      const livestreamContainer = document.querySelector('.livestream');
      if (!livestreamContainer) {
        throw new Error('[AgoraWeb] No element found with class "livestream". Ensure it exists in the DOM.');
      }
  
      // Création des pistes vidéo et audio locales
      this.localVideoTrack = await AgoraRTC.createCameraVideoTrack();
      this.localAudioTrack = await AgoraRTC.createMicrophoneAudioTrack();
      console.log('[AgoraWeb] Local video and audio tracks created');
  
      // Crée un conteneur pour la vidéo locale
      const videoContainer = document.createElement('div');
      videoContainer.id = 'local-video';
      videoContainer.style.width = '100%';
      videoContainer.style.height = '100%';
  
      // Ajoute le conteneur vidéo à la div avec la classe "livestream"
      livestreamContainer.appendChild(videoContainer);
      console.log('[AgoraWeb] Video container added to .livestream');
  
      // Lecture de la vidéo locale dans le conteneur
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

    // Rejoindre un canal avec le client et les pistes locales
    await this.client.join(options.token, options.channelName, options.uid);
    console.log('[AgoraWeb] Joined channel:', options.channelName);

    if (this.localAudioTrack && this.localVideoTrack) {
      await this.client.publish([this.localAudioTrack, this.localVideoTrack]);
      console.log('[AgoraWeb] Local audio and video tracks published');
    }
  }

  async switchCamera(): Promise<void> {
    console.log('[AgoraWeb] switchCamera called');

    if (!this.localVideoTrack) {
      throw new Error('[AgoraWeb] Local video track is not initialized.');
    }

    await this.localVideoTrack.setDevice('next');
    console.log('[AgoraWeb] Camera switched');
  }

  async leaveChannel(): Promise<void> {
    console.log('[AgoraWeb] leaveChannel called');

    if (!this.client) {
      throw new Error('[AgoraWeb] Client is not initialized.');
    }

    // Arrête les pistes locales
    if (this.localVideoTrack) {
      this.localVideoTrack.stop();
      this.localVideoTrack.close();
    }
    if (this.localAudioTrack) {
      this.localAudioTrack.stop();
      this.localAudioTrack.close();
    }

    // Quitte le canal
    await this.client.leave();
    console.log('[AgoraWeb] Left channel');
  }

  async enableWebViewTransparency(): Promise<void> {
    console.log('[AgoraWeb] enableWebViewTransparency called');
    // Implémentation Web spécifique si applicable
    throw this.unimplemented('[AgoraWeb] enableWebViewTransparency is not implemented on the web.');
  }

  async disableWebViewTransparency(): Promise<void> {
    console.log('[AgoraWeb] disableWebViewTransparency called');
    // Implémentation Web spécifique si applicable
    throw this.unimplemented('[AgoraWeb] disableWebViewTransparency is not implemented on the web.');
  }
}
