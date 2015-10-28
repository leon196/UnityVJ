

Shader "Hidden/Vinyl" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
	}
	SubShader {
		Pass {
			CGPROGRAM
			#pragma vertex vert_img
			#pragma fragment frag
      #define PI 3.1416

			#include "UnityCG.cginc"

			uniform sampler2D _MainTex;
			uniform sampler2D _TextureFFT;

			float4 frag(v2f_img i) : COLOR
      {
        float2 uv = i.uv;
        float4 color = tex2D(_MainTex, uv);

        float2 p = i.uv * 2.0 - 1.0;
        p.x *= _ScreenParams.x / _ScreenParams.y;
        float angle = atan2(p.y, p.x);
        float dist = length(p);
        float x = 1.0 - abs(fmod(abs(dist * 2.0), 1.0) * 2.0 - 1.0);
        float fft = tex2D(_TextureFFT, float2(x, 0)).r;
        float scale = fft * 0.5;

        uv.x = cos(angle + scale) * (dist + scale);
        uv.y = sin(angle + scale) * (dist + scale);
        uv.x = fmod(abs(uv.x), 1.0);
        uv.y = fmod(abs(uv.y), 1.0);

        color = tex2D(_MainTex, uv);


				return color;
			}
			ENDCG
		}
	}
}
