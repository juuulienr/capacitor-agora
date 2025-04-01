# @swipelive/capacitor-agora

Plugin Capacitor pour l'intégration d'Agora dans vos applications mobiles. Ce plugin permet d'implémenter facilement des fonctionnalités de streaming vidéo et audio en temps réel grâce à la plateforme Agora.

## 📋 Prérequis

- Capacitor 5.0 ou supérieur
- Un compte Agora avec un App ID valide
- iOS 13.0 ou supérieur
- Android API level 21 ou supérieur

## 💻 Installation

```bash
npm install @swipelive/capacitor-agora
npx cap sync
```

## 🔑 Configuration

### Android

Aucune configuration supplémentaire n'est nécessaire pour Android.

### iOS

Ajoutez les permissions suivantes dans votre fichier `Info.plist` :

```xml
<key>NSCameraUsageDescription</key>
<string>L'accès à la caméra est nécessaire pour les appels vidéo</string>
<key>NSMicrophoneUsageDescription</key>
<string>L'accès au microphone est nécessaire pour les appels audio</string>
```

## 📚 API

### Initialisation

```typescript
initialize({ appId: string }): Promise<void>
```
Initialise le SDK Agora avec votre App ID.

### Configuration Vidéo

```typescript
setupLocalVideo(): Promise<void>
```
Configure et affiche la vidéo locale.

### Gestion des Canaux

```typescript
joinChannel({ 
  channelName: string, 
  token: string | null, 
  uid: number 
}): Promise<void>
```
Rejoint un canal Agora avec les paramètres spécifiés.

```typescript
leaveChannel(): Promise<void>
```
Quitte le canal actuel et libère les ressources.

### Contrôles Caméra

```typescript
switchCamera(): Promise<void>
```
Bascule entre les caméras avant et arrière.

### Permissions

```typescript
requestPermissions(): Promise<void>
```
Demande les permissions nécessaires pour la caméra et le microphone.

## 🚀 Exemple d'utilisation

```typescript
import { CapacitorAgora } from '@swipelive/capacitor-agora';

// Initialisation
await CapacitorAgora.initialize({ appId: 'VOTRE_APP_ID' });

// Demande des permissions
await CapacitorAgora.requestPermissions();

// Configuration de la vidéo locale
await CapacitorAgora.setupLocalVideo();

// Rejoindre un canal
await CapacitorAgora.joinChannel({
  channelName: 'mon-canal',
  token: null, // ou votre token si la sécurité est activée
  uid: 0
});

// Quitter le canal
await CapacitorAgora.leaveChannel();
```

## 📝 Notes

- Assurez-vous d'avoir les permissions nécessaires avant d'initialiser la vidéo
- Gérez correctement le cycle de vie de votre application en quittant le canal lorsque nécessaire
- Pour la production, utilisez toujours un token Agora valide

## 📄 Licence

MIT
