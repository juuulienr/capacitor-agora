var capacitorAgora = (function (exports, core) {
    'use strict';

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

    return exports;

})({}, capacitorExports);
//# sourceMappingURL=plugin.js.map
