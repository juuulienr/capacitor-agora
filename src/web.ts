import { WebPlugin } from '@capacitor/core';
import type { AgoraPlugin } from './definitions';

export class AgoraWeb extends WebPlugin implements AgoraPlugin {
  private client: any;
  private localVideoTrack: any;
  private localAudioTrack: any;
  private appId: string | null = null;

  async initialize(options: { appId: string }): Promise<void> {
    const AgoraRTC = (window as any).AgoraRTC;
    if (!AgoraRTC) {
      throw new Error('[AgoraWeb] AgoraRTC is not available. Ensure you included the AgoraRTC script.');
    }

    if (!options.appId) {
      throw new Error('App ID is required');
    }

    this.appId = options.appId;
    this.client = AgoraRTC.createClient({ mode: 'live', codec: 'vp8' });
    console.log('[AgoraWeb] AgoraRTC client created');
  }

  async setupLocalVideo(): Promise<void> {
    const AgoraRTC = (window as any).AgoraRTC;
    if (!AgoraRTC) {
      throw new Error('[AgoraWeb] AgoraRTC is not available.');
    }

    try {
      const livestreamContainer = document.querySelector('.livestream');
      if (!livestreamContainer) {
        throw new Error('[AgoraWeb] No element found with class "livestream". Ensure it exists in the DOM.');
      }

      this.localAudioTrack = await AgoraRTC.createMicrophoneAudioTrack();
      this.localVideoTrack = await AgoraRTC.createCameraVideoTrack({ 
        encoderConfig: '1080p'
      });

      const videoContainer = document.createElement('div');
      videoContainer.id = 'local-video';
      videoContainer.style.width = '100%';
      videoContainer.style.height = '100%';

      livestreamContainer.appendChild(videoContainer);
      this.localVideoTrack.play('local-video');
      console.log('[AgoraWeb] Local video track started');
    } catch (error) {
      console.error('[AgoraWeb] Error in setupLocalVideo:', error);
      throw error;
    }
  }

  async joinChannel(options: { channelName: string; token: string | null; uid: number }): Promise<void> {
    if (!this.client) {
      throw new Error('Client is not initialized. Call initialize() first.');
    }
  
    if (!this.appId) {
      throw new Error('App ID is not initialized. Call initialize() first.');
    }
  
    try {
      await this.client.setClientRole('host');
      await this.client.join(this.appId, options.channelName, options.token, options.uid);
      console.log('[AgoraWeb] Successfully joined channel:', options.channelName);
  
      if (this.localAudioTrack && this.localVideoTrack) {
        await this.client.publish([this.localAudioTrack, this.localVideoTrack]);
        console.log('[AgoraWeb] Local audio and video tracks published');
      }
    } catch (error) {
      console.error('[AgoraWeb] Error while joining channel:', error);
      throw error;
    }
  }

  async leaveChannel(): Promise<void> {
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
    
    const localVideoDiv = document.getElementById('local-video');
    if (localVideoDiv) {
      localVideoDiv.remove();
      console.log('[AgoraWeb] Local video div removed');
    }

    await this.client.leave();
    console.log('[AgoraWeb] Left channel');
  }
  
  async switchCamera(): Promise<void> {
    console.log('[AgoraWeb] switchCamera called');
    throw this.unimplemented('[AgoraWeb] switchCamera is not implemented on the web.');
  }
  
  async requestPermissions(): Promise<void> {
    console.log('[AgoraWeb] requestPermissions called');
    throw this.unimplemented('[AgoraWeb] requestPermissions is not implemented on the web.');
  }
}
