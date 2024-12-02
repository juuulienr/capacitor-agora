import { WebPlugin } from '@capacitor/core';
export class AgoraWeb extends WebPlugin {
    async initialize(options) {
        console.log('AgoraWeb: initialize called with', options);
        // Implémentation côté web (si applicable)
        throw this.unimplemented('initialize is not implemented on the web.');
    }
    async setupLocalVideo() {
        console.log('AgoraWeb: setupLocalVideo called');
        // Implémentation côté web (si applicable)
        throw this.unimplemented('setupLocalVideo is not implemented on the web.');
    }
    async joinChannel(options) {
        console.log('AgoraWeb: joinChannel called with', options);
        // Implémentation côté web (si applicable)
        throw this.unimplemented('joinChannel is not implemented on the web.');
    }
    async switchCamera() {
        console.log('AgoraWeb: switchCamera called');
        // Implémentation côté web (si applicable)
        throw this.unimplemented('switchCamera is not implemented on the web.');
    }
    async leaveChannel() {
        console.log('AgoraWeb: leaveChannel called');
        // Implémentation côté web (si applicable)
        throw this.unimplemented('leaveChannel is not implemented on the web.');
    }
}
//# sourceMappingURL=web.js.map