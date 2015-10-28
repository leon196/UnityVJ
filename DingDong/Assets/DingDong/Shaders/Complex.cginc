// Many thanks to  Brandon Pelfrey
// https://github.com/brandonpelfrey/complex-function-plot/blob/master/index.htm

#define M_E 2.7182818284

float arg(float2 x) { return atan2(x.y, x.x); }
float complex_r(float x, float y) { return length(float2(x,y)); }
float complex_theta(float x, float y) { return arg(float2(x,y)); }
float2 complex(float x, float y) { return float2(x,y); }

// https://en.wikipedia.org/wiki/Complex_number#Elementary_operations
float2 complex_add(float2 x, float2 y) { return x + y; }
float2 complex_sub(float2 x, float2 y) { return x - y; }
float2 complex_mul(float2 x, float2 y) { return float2( x.x*y.x-x.y*y.y, x.y*y.x+x.x*y.y); }
float2 complex_div(float2 x, float2 y) { return float2( (x.x*y.x+x.y*y.y)/(y.x*y.x+y.y*y.y), (x.y*y.x-x.x*y.y)/(y.x*y.x+y.y*y.y)); }

// http://www.abecedarical.com/zenosamples/zs_complexnumbers.html
float2 complex_pow(float2 x, float2 y) {
  float rho = length(x);
  float theta = arg(x);
  float angle = y.x * theta + y.y * log(rho);
  float real = cos(angle);
  float imag = sin(angle);
  return float2(real, imag) * (pow(rho, y.x) * pow(M_E, -y.y * theta));
}

float2 complex_sin(float2 x) {
  float2 iz = complex_mul(float2(0.0, 1.0), x);
  float2 inz = complex_mul(float2(0.0, -1.0), x);
  float2 eiz = complex_pow( float2(M_E, 0.0), iz );
  float2 einz = complex_pow( float2(M_E, 0.0), inz );
  return complex_div( eiz - einz, float2(0.0, 2.0));
}

float2 complex_cos(float2 x) {
  float2 iz = complex_mul(float2(0.0, 1.0), x);
  float2 inz = complex_mul(float2(0.0, -1.0), x);
  float2 eiz = complex_pow( float2(M_E, 0.0), iz );
  float2 einz = complex_pow( float2(M_E, 0.0), inz );
  return complex_div( eiz + einz, float2(2.0, 0.0));
}

float2 complex_log(float2 x) {
  return float2( log( length(x) ), arg(x) );
}
