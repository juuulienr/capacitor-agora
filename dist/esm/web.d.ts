import { WebPlugin } from '@capacitor/core';
import type { AgoraPlugin } from './definitions';
export declare class AgoraWeb extends WebPlugin implements AgoraPlugin {
    echo(options: {
        value: string;
    }): Promise<{
        value: string;
    }>;
}
