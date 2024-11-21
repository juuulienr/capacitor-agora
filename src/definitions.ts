export interface AgoraPlugin {
  echo(options: { value: string }): Promise<{ value: string }>;
}
