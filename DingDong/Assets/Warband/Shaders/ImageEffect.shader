

Shader "Hidden/BWDiffuse" {
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

			uniform sampler2D _MainTex;
			uniform float _bwBlend;

			float4 frag(v2f_img i) : COLOR
      {
        float2 uv = i.uv;
        float2 p = uv - float2(0.5, 0.5);
        float2 dir = normalize(p);
        float radius = length(p);
        float angle = atan2(dir.y, dir.x);
        uv.x = fmod(abs(log(radius)), 1.0);
        uv.y = fmod(abs(angle), 1.0);
				float4 c = tex2D(_MainTex, uv);

				float lum = c.r*.3 + c.g*.59 + c.b*.11;
				float3 bw = float3( lum, lum, lum );

				float4 result = c;
				result.rgb = lerp(c.rgb, bw, _bwBlend);
				return result;
			}
			ENDCG
		}
	}
}
