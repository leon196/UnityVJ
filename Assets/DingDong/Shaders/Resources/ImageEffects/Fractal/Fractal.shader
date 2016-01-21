Shader "Hidden/Fractal" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
	}
	SubShader {
		Pass {
			CGPROGRAM
			#pragma vertex vert_img
			#pragma fragment frag
      #pragma target 3.0

			#include "UnityCG.cginc"
      #include "../../Utils/Utils.cginc"
      #include "../../Utils/Complex.cginc"
      #define PIHalf 1.570796327
      #define RADTier 2.094395102
      #define RAD2Tier 4.188790205

      sampler2D _MainTex;
      sampler2D _WebcamTexture;
      float _GlobalFFT;
      float _GlobalFFTTotal;
      float2 _Mouse;

      // Thanks to David Bau
      // http://davidbau.com/archives/2013/02/10/conformal_map_viewer.html

      // Thanks to John Tsiombikas
      // for http://nuclear.mutantstargoat.com/articles/sdr_fract/

      #define iter 16

      fixed4 Julia (float2 uv)
      {
        float2 z = 2.0 * (uv - float2(0.5, 0.5));
        float t = _Time * 5.;
        // float2 c = _Mouse / _ScreenParams.xy;
        // c.x *= uResolution.x / uResolution.y;
        float2 c = float2(0.32, 0.039) + float2(sin(t) * 0.05, cos(t) * 0.1);

        float2 p = float2(0., 0.);
        float d = 9999.9;

        int ii = 0;
        for(int i=0; i < iter; i++)
        {
          float x = (z.x * z.x - z.y * z.y) + c.x;
          float y = (z.y * z.x + z.x * z.y) + c.y;

          float2 zMinusPoint = float2(z.x - p.x, z.y - p.y);
          if(length(zMinusPoint) < d) {
            d = length(zMinusPoint);
          }

          ii++;
          if((x * x + y * y) >4.0) break;
          z.x = x;
          z.y = y;
        }

        uv = fmod(abs(z), 1.0);
        // a += uTime * 0.2 *
        uv.x = lerp(1.0 - uv.x, uv.x, fmod(abs(floor(z.x)), 2.0));
        uv.y = lerp(1.0 - uv.y, uv.y, fmod(abs(floor(z.y)), 2.0));
      // fmod(abs(z.xy)
        float4 color = tex2D(_MainTex, uv);

        float ratio = ii == iter ? 0.0 : float(ii) / float(iter);
        float ratio2 = length(z);
        // color.rgb = lerp(color.rgb, float3(0.0), ratio2);
        // color.rgb = lerp(float3(1,1,1), color.rgb, color.a);
        // color.rgb = lerp(color.rgb, float3(0,0,0), clamp(ratio,0.0,1.0) * ratio2);
        // color.rgb = lerp(color.rgb, float3(0,0,0), d);

        return color;
      }


      float4 frag(v2f_img i) : COLOR
      {
        float2 uv = i.uv * 2.0 - 1.0;
        uv.x *= _ScreenParams.x / _ScreenParams.y;
        uv *= 5.;
        float t = _Time * 10.0;

        float angle = atan2(uv.y, uv.x);// + _Time * 2.0;
        float dist = length(uv);
        uv = float2(cos(angle), sin(angle)) * dist;

        uv = complex_div(1.0, uv);


        uv.x = kaleido(uv.x, 0.);
        uv.y = kaleido(uv.y, t);

        float4 color = tex2D(_MainTex, uv);

        return color;
      }
      ENDCG
    }
  }
}
