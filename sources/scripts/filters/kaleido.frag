precision mediump float;

varying vec2 vTextureCoord;
varying vec4 vColor;

uniform float uTime;
uniform float uPixelSize;
uniform float uBufferTreshold;
uniform float uFilter5x5Gaussian[25];
uniform float uFilter5x5Neighbor[25];
uniform float uFilter3x3Neighbor[9];
uniform vec2 uResolution;
uniform sampler2D uSampler;
uniform sampler2D uBuffer;
uniform sampler2D uVideo;

#define PI 3.141592653589
#define PI2 6.283185307179
#define PIHalf 1.570796327
#define RADTier 2.094395102
#define RAD2Tier 4.188790205

float luminance ( vec3 color ) { return (color.r + color.g + color.b) / 3.0; }
vec2 pixelize(vec2 uv, vec2 segments) { return floor(uv * segments) / segments; }
vec4 filter5x5 (float filter[25], sampler2D bitmap, vec2 uv, vec2 dimension)
{
  vec4 color = vec4(0.);
  for (int i = 0; i < 5; ++i)
    for (int j = 0; j < 5; ++j)
      color += filter[i * 5 + j] * texture2D(bitmap, uv + vec2(i - 2, j - 2) / dimension);
  return color;
}
vec4 filter3x3 (float filter[9], sampler2D bitmap, vec2 uv, vec2 dimension)
{
  vec4 color = vec4(0.);
  for (int i = 0; i < 3; ++i)
    for (int j = 0; j < 3; ++j)
      color += filter[i * 3 + j] * texture2D(bitmap, uv + vec2(i - 1, j - 1) / dimension);
  return color;
}

void main(void)
{
  // OFFSET FROM CENTER
  vec2 center = vTextureCoord * 2.0 - 1.0;
  center.x *= uResolution.x / uResolution.y;
  float dist = length(center);
  float angle = atan(center.y, center.x);

  float d = log(dist);
  d += uTime * 0.4 * mix(-1.0, 1.0, mod(floor(d), 2.0));
  d = mix(1.0 - d, d, mod(floor(d), 2.0));

  float a = angle / PI * 4.0;
  a += uTime * 0.2 * mix(-1.0, 1.0, mod(floor(a), 2.0));
  a = mix(1.0 - a, a, mod(floor(a), 2.0));

  vec2 uv = mod(vec2(a, d), 1.0);

  vec4 video = texture2D(uVideo, uv);
  vec4 renderTarget = texture2D(uBuffer, vTextureCoord);
  renderTarget.rgb *= 0.95;

  // vec4 neighbor = clamp(filter5x5(uFilter5x5Neighbor, uBuffer, vTextureCoord, uResolution), 0.0, 1.0);
  // renderTarget = mix(renderTarget, neighbor, 0.9);//luminance(renderTarget.rgb));


  vec4 color = mix(renderTarget, video, step(uBufferTreshold, distance(video.rgb, renderTarget.rgb)));

  gl_FragColor = color;
}
