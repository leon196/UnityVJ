precision mediump float;

varying vec2 vTextureCoord;
varying vec4 vColor;

uniform sampler2D uSampler;
uniform sampler2D buffer;
uniform float gray;

void main(void)
{
  vec4 video = texture2D(uSampler, vTextureCoord);
  vec4 renderTarget = texture2D(buffer, vTextureCoord);

  vec4 color = mix(renderTarget, video, step(0.75, distance(video.rgb, renderTarget.rgb)));

  gl_FragColor = color;
}
