import { WebPlugin } from '@capacitor/core';

import type { AgoraPlugin } from './definitions';

export class AgoraWeb extends WebPlugin implements AgoraPlugin {
  async echo(options: { value: string }): Promise<{ value: string }> {
    console.log('ECHO', options);
    return options;
  }
}
