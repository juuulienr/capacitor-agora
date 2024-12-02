# @swipelive/capacitor-agora

Capacitor plugin for integrating Agora

## Install

```bash
npm install @swipelive/capacitor-agora
npx cap sync
```

## API

<docgen-index>

* [`initialize(...)`](#initialize)
* [`setupLocalVideo()`](#setuplocalvideo)
* [`joinChannel(...)`](#joinchannel)
* [`switchCamera()`](#switchcamera)
* [`leaveChannel()`](#leavechannel)
* [`enableWebViewTransparency()`](#enablewebviewtransparency)
* [`disableWebViewTransparency()`](#disablewebviewtransparency)

</docgen-index>

<docgen-api>
<!--Update the source file JSDoc comments and rerun docgen to update the docs below-->

### initialize(...)

```typescript
initialize(options: { appId: string; }) => Promise<void>
```

Initialise le SDK Agora avec l'App ID.

| Param         | Type                            | Description                       |
| ------------- | ------------------------------- | --------------------------------- |
| **`options`** | <code>{ appId: string; }</code> | - Les options contenant l'App ID. |

--------------------


### setupLocalVideo()

```typescript
setupLocalVideo() => Promise<void>
```

Configure et affiche la vidéo locale.

--------------------


### joinChannel(...)

```typescript
joinChannel(options: { channelName: string; token: string | null; uid: number; }) => Promise<void>
```

Rejoint un canal Agora avec les informations fournies.

| Param         | Type                                                                      | Description                                                  |
| ------------- | ------------------------------------------------------------------------- | ------------------------------------------------------------ |
| **`options`** | <code>{ channelName: string; token: string \| null; uid: number; }</code> | - Les options contenant le nom du canal, le token, et l'UID. |

--------------------


### switchCamera()

```typescript
switchCamera() => Promise<void>
```

Permet de basculer entre les caméras (avant/arrière).

--------------------


### leaveChannel()

```typescript
leaveChannel() => Promise<void>
```

Quitte le canal actuel et libère les ressources.

--------------------


### enableWebViewTransparency()

```typescript
enableWebViewTransparency() => Promise<void>
```

Active la transparence de la WebView pour afficher les éléments en arrière-plan.

--------------------


### disableWebViewTransparency()

```typescript
disableWebViewTransparency() => Promise<void>
```

Désactive la transparence de la WebView.

--------------------

</docgen-api>
