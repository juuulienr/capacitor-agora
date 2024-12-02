import { WebPlugin } from '@capacitor/core';
import type { AgoraPlugin } from './definitions';

export class AgoraWeb extends WebPlugin implements AgoraPlugin {
  async initialize(options: { appId: string }): Promise<void> {
    console.log('AgoraWeb: initialize called with', options);
    // Implémentation côté web (si applicable)
    throw this.unimplemented('initialize is not implemented on the web.');
  }

  async setupLocalVideo(): Promise<void> {
    console.log('AgoraWeb: setupLocalVideo called');
    // Implémentation côté web (si applicable)
    throw this.unimplemented('setupLocalVideo is not implemented on the web.');
  }

  async joinChannel(options: { channelName: string; token: string | null; uid: number }): Promise<void> {
    console.log('AgoraWeb: joinChannel called with', options);
    // Implémentation côté web (si applicable)
    throw this.unimplemented('joinChannel is not implemented on the web.');
  }

  async switchCamera(): Promise<void> {
    console.log('AgoraWeb: switchCamera called');
    // Implémentation côté web (si applicable)
    throw this.unimplemented('switchCamera is not implemented on the web.');
  }

  async leaveChannel(): Promise<void> {
    console.log('AgoraWeb: leaveChannel called');
    // Implémentation côté web (si applicable)
    throw this.unimplemented('leaveChannel is not implemented on the web.');
  }
}
