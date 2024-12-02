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

</docgen-index>

<docgen-api>
<!--Update the source file JSDoc comments and rerun docgen to update the docs below-->

### initialize(...)

```typescript
initialize(options: { appId: string; }) => Promise<void>
```

| Param         | Type                            |
| ------------- | ------------------------------- |
| **`options`** | <code>{ appId: string; }</code> |

--------------------


### setupLocalVideo()

```typescript
setupLocalVideo() => Promise<void>
```

--------------------


### joinChannel(...)

```typescript
joinChannel(options: { channelName: string; token: string | null; uid: number; }) => Promise<void>
```

| Param         | Type                                                                      |
| ------------- | ------------------------------------------------------------------------- |
| **`options`** | <code>{ channelName: string; token: string \| null; uid: number; }</code> |

--------------------


### switchCamera()

```typescript
switchCamera() => Promise<void>
```

--------------------


### leaveChannel()

```typescript
leaveChannel() => Promise<void>
```

--------------------

</docgen-api>
