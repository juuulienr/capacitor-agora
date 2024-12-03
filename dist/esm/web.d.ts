import { WebPlugin } from '@capacitor/core';
import type { AgoraPlugin } from './definitions';
export declare class AgoraWeb extends WebPlugin implements AgoraPlugin {
    private client;
    private localVideoTrack;
    private localAudioTrack;
    private appId;
    initialize(options: {
        appId: string;
    }): Promise<void>;
    setupLocalVideo(): Promise<void>;
    joinChannel(options: {
        channelName: string;
        token: string | null;
        uid: number;
    }): Promise<void>;
    switchCamera(): Promise<void>;
    leaveChannel(): Promise<void>;
    enableWebViewTransparency(): Promise<void>;
    disableWebViewTransparency(): Promise<void>;
}
