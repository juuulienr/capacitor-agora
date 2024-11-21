import { registerPlugin } from '@capacitor/core';
const Agora = registerPlugin('Agora', {
    web: () => import('./web').then((m) => new m.AgoraWeb()),
});
export * from './definitions';
export { Agora };
//# sourceMappingURL=index.js.map