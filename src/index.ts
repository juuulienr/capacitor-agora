import { registerPlugin } from '@capacitor/core';

import type { AgoraPlugin } from './definitions';

const Agora = registerPlugin<AgoraPlugin>('Agora', {
  web: () => import('./web').then((m) => new m.AgoraWeb()),
});

export * from './definitions';
export { Agora };
