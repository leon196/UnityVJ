// From http://nuclear.mutantstargoat.com/articles/sdr_fract/

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
uniform float uPixelSize;
uniform float uFrequenceTotal;
uniform float uBufferTreshold;
uniform float uFilter5x5Gaussian[25];
uniform float uFilter5x5Neighbor[25];
uniform float uFilter3x3Neighbor[9];
uniform vec2 uResolution;
uniform sampler2D uSampler;
uniform sampler2D uBuffer;
uniform sampler2D uVideo;

const int iter = 4;

void main(void)
{
  vec2 z;
  vec2 c = uMouse / uResolution * 0.5;
  z.x = 3.0 * (vTextureCoord.x - 0.5);
  z.y = 2.0 * (vTextureCoord.y - 0.5);
  int ii = 0;
  for(int i=0; i<iter; i++) {
    float x = (z.x * z.x - z.y * z.y) + c.x;
    float y = (z.y * z.x + z.x * z.y) + c.y;

    ii++;
    if((x * x + y * y) > 4.0) break;
    z.x = x;
    z.y = y;
  }

  vec4 color = texture2D(uVideo, mod(abs(z.xy), 1.0));
  float ratio = ii == iter ? 0.0 : float(ii) / 10.0;
  // color.rgb *= 1.0 - ratio;
  gl_FragColor = color;
}
