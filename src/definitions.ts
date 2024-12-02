export interface AgoraPlugin {
  /**
   * Initialise le SDK Agora avec l'App ID.
   * @param options - Les options contenant l'App ID.
   */
  initialize(options: { appId: string }): Promise<void>;

  /**
   * Configure et affiche la vidéo locale.
   */
  setupLocalVideo(): Promise<void>;

  /**
   * Rejoint un canal Agora avec les informations fournies.
   * @param options - Les options contenant le nom du canal, le token, et l'UID.
   */
  joinChannel(options: { channelName: string; token: string | null; uid: number }): Promise<void>;

  /**
   * Permet de basculer entre les caméras (avant/arrière).
   */
  switchCamera(): Promise<void>;

  /**
   * Quitte le canal actuel et libère les ressources.
   */
  leaveChannel(): Promise<void>;

  /**
   * Active la transparence de la WebView pour afficher les éléments en arrière-plan.
   */
  enableWebViewTransparency(): Promise<void>;

  /**
   * Désactive la transparence de la WebView.
   */
  disableWebViewTransparency(): Promise<void>;
}
