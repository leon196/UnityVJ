precision mediump float;

varying vec2 vTextureCoord;
varying vec4 vColor;

uniform float uTime;
uniform float uPixelSize;
uniform float uFilter[25];
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
  vec2 uv = pixelize(vTextureCoord, uResolution / uPixelSize);

  // RGB OFFSET
  vec4 video = vec4(1.0);
  float rgbOffsetRadius = 0.01;
  float angle = uTime * 2.0;
  video.r = texture2D(uVideo, uv + vec2(cos(angle), sin(angle)) * rgbOffsetRadius).r;
  video.g = texture2D(uVideo, uv + vec2(cos(angle + RADTier), sin(angle + RADTier)) * rgbOffsetRadius).g;
  video.b = texture2D(uVideo, uv + vec2(cos(angle + RAD2Tier), sin(angle + RAD2Tier)) * rgbOffsetRadius).b;

  // OFFSET FROM CENTER
  vec2 center = vTextureCoord * 2.0 - 1.0;
  //(uv - 0.5) * (uPixelSize);
  float dist = length(center);
  angle = atan(center.y, center.x);
  vec2 offset = vec2(cos(angle), sin(angle)) * dist * 0.01;

  // OFFSET FROM COLOR
  vec4 renderTarget = texture2D(uBuffer, uv);
  float lumBuffer = luminance(renderTarget.rgb);
  float lumVideo = luminance(video.rgb);

  angle = (lumBuffer + lumVideo) * PI2;
  offset += vec2(cos(angle), sin(angle)) * 0.005;// * (0.1 + lum);
  renderTarget = texture2D(uBuffer, uv - offset);

  //renderTarget.rgb *= 0.99;
  // renderTarget.rgb *= 1.01;

  vec4 color = mix(renderTarget, video, step(0.5, luminance(abs(video.rgb - renderTarget.rgb))));

  vec4 edge = clamp(filter5x5(uFilter, uVideo, vTextureCoord, uResolution / 4.0) - 1.0, 0.0, 1.0);
  float treshold = luminance(edge.rgb);
  color = mix(color, video, treshold);


  gl_FragColor = color;
}
