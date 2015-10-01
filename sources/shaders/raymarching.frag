precision mediump float;

varying vec2 vTextureCoord;
varying vec4 vColor;

uniform float uTime;
uniform float uPixelSize;
uniform float uFrequenceTotal;
uniform float uBufferTreshold;
uniform vec2 uResolution;
uniform vec2 uMouse;
uniform vec2 uMousePan;
uniform vec3 uPosition;
uniform float uAngleX;
uniform float uAngleY;
uniform sampler2D uSampler;
uniform sampler2D uBuffer;
uniform sampler2D uVideo;

#define PI 3.141592653589
#define PI2 6.283185307179
#define PIHalf 1.570796327
#define RADTier 2.094395102
#define RAD2Tier 4.188790205

// thank to @iquilezles -> http://www.iquilezles.org/www/index.htm
// thank to @uint9 -> http://9bitscience.blogspot.fr/2013/07/raymarching-distance-fields_14.html

// Dat random function for glsl
float rand(vec2 co){ return fract(sin(dot(co.xy, vec2(12.9898,78.233))) * 43758.5453); }

// Pixelize coordinates
vec2 pixelize(vec2 uv, float details) { return floor(uv.xy * details) / details; }
//float noise ( vec2 seed ) { return texture2DRect(uNoise, seed * uNoiseResolution).r; }
vec2 pixelate ( vec2 pixel, vec2 details ) { return floor(pixel * details) / details; }
vec3 posterize ( vec3 color, float details ) { return floor(color * details) / details; }
float luminance ( vec3 color ) { return (color.r + color.g + color.b) / 3.0; }

// Raymarching
const float rayEpsilon = 0.01;
const float rayMin = 0.1;
const float rayMax = 1e6;
const int rayCount = 32;
const int iter = 16;

// Camera
vec3 eye = vec3(0.0001, 0.0001, 0.0001);
vec3 front = vec3(0.0, 0.0, 1.0);
vec3 right = vec3(1.0, 0.0, 0.0);
vec3 up = vec3(0.0, 1.0, 0.0);

// Colors
vec3 sphereColor = vec3(0, 0.5, 0.0);
vec3 skyColor = vec3(0.0, 0.0, 0.0);
vec3 shadowColor = vec3(0.0, 0.0, 0.0);
vec3 fogColor  = vec3(0.5,0.0,0.0);

// Animation
float sphereRadius = 0.8;

// @iquilezles
float sphere ( vec3 p, float s )
{
  return length(p)-s;
}

  // hash based 3d value noise
  // function taken from https://www.shadertoy.com/view/XslGRr
  // Created by inigo quilez - iq/2013
  // License Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License.

  // ported from GLSL to HLSL
  float hash( float n )
  {
    return fract(sin(n)*43758.5453);
  }

  // @iquilezles
  float noise( vec3 x )
  {
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

  // @iquilezles
  float plane( vec3 p, vec4 n )
  {
    // n must be normalized
    return dot(p,n.xyz) + n.w;
  }

  // polynomial smooth min (k = 0.1);
  float smin( float a, float b, float k )
  {
   float h = clamp( 0.5+0.5*(b-a)/k, 0.0, 1.0 );
   return mix( b, a, h ) - k*h*(1.0-h);
  }

  vec3 rotateY(vec3 v, float t)
  {
      float cost = cos(t); float sint = sin(t);
      return vec3(v.x * cost + v.z * sint, v.y, -v.x * sint + v.z * cost);
  }

  vec3 rotateX(vec3 v, float t)
  {
      float cost = cos(t); float sint = sin(t);
      return vec3(v.x, v.y * cost - v.z * sint, v.y * sint + v.z * cost);
  }

  float scene (in vec3 p)
  {
    //p += noise(p * 10.0 + vec3(0.0,0.0,uTime)) * 0.1;
    float pla = plane(p, vec4(0.0, -1.0, 0.0, 1.0 + 4.0 * (sin(uTime) * 0.5 + 0.5)));
    p = mod(p, 2.0) - 1.0;
    float sph = sphere(p, sphereRadius);
    return smin(sph, pla, 0.25);
  }

  void main( void )
  {
    vec2 uv = vTextureCoord * 2.0 - 1.0;
    uv.x *= uResolution.x / uResolution.y;

    vec3 ray = normalize(front + right * uv.x + up * uv.y);

    vec3 color = skyColor;

    // Raymarching
    float t = 0.0;
    for (int r = 0; r < rayCount; ++r)
    {

      // Ray Position
      vec3 p = ray * t;

      p = rotateX(p, uMousePan.y / uResolution.y * 4.0);
      p = rotateY(p, -uMousePan.x / uResolution.x * 4.0);

      p += uPosition;

      float d = scene(p);

      // Distance min or max reached
      if (d < rayEpsilon || t > rayMax)
      {
        // Shadow from ray count
        // color = normalize(p) * 0.5 + 0.5;
        uv = vec2(dot(eye,p) * 10000.0, p.y);
        uv = mod(abs(uv), 1.0);
        color = texture2D(uVideo, uv).rgb;
        color = mix(color, shadowColor, float(r) / float(rayCount));
        // Sky color from distance
        color = mix(color, skyColor, smoothstep(rayMin, rayMax, t));
        break;
      }

      //color *= shadow(vec3(1.0, -4.0, 0.0), normalize(vec3(1.0, -1.0, 0.0)));

      //color = applyFog(color, d);


      // Distance field step
      t += d;
    }
    gl_FragColor = vec4( color, 1.0 );
  }
