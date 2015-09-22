precision mediump float;

varying vec2 vTextureCoord;
varying vec4 vColor;

uniform float uTime;
uniform float uFrequenceTotal;
uniform float uPixelSize;
uniform float uBufferTreshold;
uniform float uFilter5x5Gaussian[25];
uniform float uFilter5x5Neighbor[25];
uniform float uFilter3x3Neighbor[9];
uniform vec2 uResolution;
uniform sampler2D uSampler;
uniform sampler2D uBuffer;
uniform sampler2D uVideo;
uniform sampler2D uFrequenceTexture;

#define PI 3.141592653589
#define PI2 6.283185307179
#define PIHalf 1.570796327
#define RADTier 2.094395102
#define RAD2Tier 4.188790205

float rand(vec2 co){ return fract(sin(dot(co.xy, vec2(12.9898,78.233))) * 43758.5453); }
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

// hash based 3d value noise
// function taken from https://www.shadertoy.com/view/XslGRr
// Created by inigo quilez - iq/2013
// License Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License.
float hash( float n ) { return fract(sin(n)*43758.5453); }
float noise( vec3 x ) {
    // The noise function returns a value in the range -1.0f -> 1.0f
    vec3 p = floor(x);
    vec3 f = fract(x);
    f       = f*f*(3.0-2.0*f);
    float n = p.x + p.y*57.0 + 113.0*p.z;
    return mix(mix(mix( hash(n+0.0), hash(n+1.0),f.x),
                   mix( hash(n+57.0), hash(n+58.0),f.x),f.y),
               mix(mix( hash(n+113.0), hash(n+114.0),f.x),
                   mix( hash(n+170.0), hash(n+171.0),f.x),f.y),f.z);
}

void main(void)
{
  vec2 uv = vTextureCoord;//pixelize(vTextureCoord, uResolution / uPixelSize);

  vec4 video = texture2D(uVideo, uv);
  float t = cos(uTime * 2.0) * 0.5 + 0.5;
  vec2 center = uv - vec2(0.5);
  float dist = length(center.xx) * 4.0 * noise(vec3(center.yy * 1000.0, 0.0)) ;
  // float angle = atan(center.y, center.x);//noise(video.rgb);
  float dirX = mix(-1.0, 1.0,step(0.5, uv.x));
  // float dirY = mix(-1.0, 1.0,step(0.5, uv.y));
  vec2 offset = vec2(dirX,0.0) * 0.002 * (dist + 1.0);//vec2(0.5, 0.5) * angle * 0.4;
  // vec2 offset = vec2(cos(angle), sin(angle)) * 0.001;
  vec4 renderTarget = texture2D(uBuffer, uv - offset);

  float lum = luminance(renderTarget.rgb);

  renderTarget = texture2D(uBuffer, uv - offset * ((1.0-lum) + 1.0));



  renderTarget.rgb *= 0.99;

  vec4 color = mix(renderTarget, video, clamp(step(dist, t * 0.15 + 0.1), 0.0, 1.0));
  // vec4 color = mix(renderTarget, video, step(dist, t * 0.25));
  // vec4 color = mix(renderTarget, video, step(0.5, luminance(abs(video.rgb - renderTarget.rgb))));
  // color.rgb = vec3(1.0) * dist;
  gl_FragColor = color;
}
