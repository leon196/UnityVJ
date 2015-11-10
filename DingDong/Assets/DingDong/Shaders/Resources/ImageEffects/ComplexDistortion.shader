

Shader "Hidden/ComplexDistortion" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_bwBlend ("Black & White blend", Range (0, 1)) = 0
	}
	SubShader {
		Pass {
			CGPROGRAM
			#pragma vertex vert_img
			#pragma fragment frag

			#include "UnityCG.cginc"
          #include "../Utils/Complex.cginc"

          uniform sampler2D _MainTex;
          uniform float _bwBlend;
          uniform float _GlobalFFTTotal;

      // Many Thanks to David Bau
      // http://davidbau.com/archives/2013/02/10/conformal_map_viewer.html

      float4 frag(v2f_img i) : COLOR
      {
        float2 uv = i.uv * 2.0 - 1.0;
        uv.x *= _ScreenParams.x / _ScreenParams.y;
        uv = complex_mul(uv, uv);
        /*uv = complex_sin(uv);*/
        /*uv = complex_pow(float2(M_E, M_E), uv);*/
        /*uv = complex_log(uv);*/
        /*0.926(z+
            7.3857e-2*z^5
            +(4.5458e-3*(z^9)))*/
        /*uv = (cos(_Time) * 0.5 + 0.5) * 2.926 * (complex_add(uv,
          complex_add(7.3857e-2 * complex_pow(uv, float2(5.0,5.0)),
              4.5458e-3 * complex_pow(uv, float2(9.0, 9.0)))));*/
        // z^2 - 1/z
        /*uv *= 2.0;*/
        /*uv = complex_sub(complex_mul(uv, uv), complex_div(1.0, uv));*/
        /*uv.x += _Time * 10.0;
        uv.y += _Time * 10.0;*/
        /*uv.x = fmod(abs(uv.x), 1.0);
        uv.y = fmod(abs(uv.y), 1.0);*/
        float t = _Time * 10.0;
        /*float t = _GlobalFFTTotal * 0.001;*/
        uv.x += t * lerp(-1.0, 1.0, fmod(floor(abs(uv.x)), 2.0));
        float xMod = fmod(abs(uv.x), 1.0);
        uv.x = lerp(1.0 - xMod, xMod, fmod(floor(abs(uv.x)), 2.0));
        uv.y += t * lerp(-1.0, 1.0, fmod(floor(abs(uv.y)), 2.0));
        float yMod = fmod(abs(uv.y), 1.0);
        uv.y = lerp(1.0 - yMod, yMod, fmod(floor(abs(uv.y)), 2.0));

        float4 c = tex2D(_MainTex, uv);

        float lum = c.r*.3 + c.g*.59 + c.b*.11;
        float3 bw = float3( lum, lum, lum );
        float4 result = c;
        result.rgb = lerp(c.rgb, bw, _bwBlend);
        /*result.rgb *= step(0.01, fmod(uv.x, 0.1)) * step(0.01, fmod(uv.y, 0.1));*/
        return result;
    }
    ENDCG
}
}
}
