
// Thanks to John Tsiombikas
// for http://nuclear.mutantstargoat.com/articles/sdr_fract/

precision mediump float;

#define PI 3.141592653589
#define PI2 6.283185307179
#define PIHalf 1.570796327
#define RADTier 2.094395102
#define RAD2Tier 4.188790205

varying vec2 vTextureCoord;
varying vec4 vColor;

uniform float uTime;
uniform vec2 uMouse;
uniform vec2 uMousePan;
uniform float uPixelSize;
uniform float uFrequenceTotal;
uniform float uBufferTreshold;
uniform vec2 uResolution;
uniform sampler2D uSampler;
uniform sampler2D uBuffer;
uniform sampler2D uVideo;
uniform sampler2D uImage;

const int iter = 100;

void main(void)
{
  vec2 z = 2.0 * (vTextureCoord - vec2(0.5));
  z.x *= uResolution.x / uResolution.y;

  vec2 c = uMouse / uResolution * 2.0 - 1.0;
  c.x *= uResolution.x / uResolution.y;
  // c -= 1.0;
  c *= 2.0;

  vec2 point = vec2(0.);
  float d = 9999.9;

  int ii = 0;
  for(int i=0; i<iter; i++)
  {
    float x = (z.x * z.x - z.y * z.y) + c.x;
    float y = (z.y * z.x + z.x * z.y) + c.y;
    // float x = ((z.x * z.x - z.y * z.y) + c.x) / (z.x - c.x);
    // float y = ((z.y * z.x + z.x * z.y) + c.y) / (z.y - c.y);

    vec2 zMinusPoint = vec2(z.x - point.x, z.y - point.y);
    if(length(zMinusPoint) < d) {
      d = length(zMinusPoint);
    }

    ii++;
    if((x * x + y * y) >4.0) break;
    z.x = x;
    z.y = y;
  }

  vec2 uv = mod(abs(z), 1.0);
  // a += uTime * 0.2 *
  uv.x = mix(1.0 - uv.x, uv.x, mod(floor(z.x), 2.0));
  uv.y = mix(1.0 - uv.y, uv.y, mod(floor(z.y), 2.0));
// mod(abs(z.xy)
  vec4 color = texture2D(uImage, uv);

  float ratio = ii == iter ? 0.0 : float(ii) / float(iter);
  float ratio2 = length(z);
  // color.rgb = mix(color.rgb, vec3(0.0), ratio2);
  color.rgb = mix(vec3(1.0), color.rgb, color.a);
  // color.rgb = mix(color.rgb, vec3(0.0), clamp(ratio,0.0,1.0) * ratio2);
  color.rgb = mix(color.rgb, vec3(0.0), d);
  // color.rgb = mix(color.rgb, vec3(0.0), sin(clamp(ratio,0.0,1.0)) * PI);
  // color.rgb = vec3(1.0) * clamp(z.x * z.y * z.z,  0.0, 1.0) * (1.0-ratio);
  gl_FragColor = color;
}
