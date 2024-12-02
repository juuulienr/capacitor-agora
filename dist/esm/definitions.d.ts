export interface AgoraPlugin {
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
}
