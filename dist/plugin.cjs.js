'use strict';

var core = require('@capacitor/core');

const Agora = core.registerPlugin('Agora', {
    web: () => Promise.resolve().then(function () { return web; }).then((m) => new m.AgoraWeb()),
});

class AgoraWeb extends core.WebPlugin {
    async echo(options) {
        console.log('ECHO', options);
        return options;
    }
}

var web = /*#__PURE__*/Object.freeze({
    __proto__: null,
    AgoraWeb: AgoraWeb
});

exports.Agora = Agora;
//# sourceMappingURL=plugin.cjs.js.map
