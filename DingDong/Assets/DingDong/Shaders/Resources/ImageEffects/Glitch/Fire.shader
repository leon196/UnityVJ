Shader "Hidden/Fire" {
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
			#include "../../Utils/ClassicNoise2D.cginc"

			sampler2D _MainTex;
			sampler2D _BufferTexture;
			sampler2D _DifferenceTexture;
			float _ReaktorOutput;

			half4 frag (v2f_img i) : COLOR {
				float2 uv = i.uv;
				fixed4 diff = tex2D(_DifferenceTexture, uv);
				float unit = 1.0 / _ScreenParams.x;

				float2 offset = float2(unit, 0.0);
				float angle = cnoise(uv * 1000.0 + _Time) * PI;
				offset += float2(cos(angle), sin(angle)) * unit;

				fixed4 buffer = tex2D(_BufferTexture, uv + offset);
				buffer.rgb *= 0.98;

				fixed4 color = lerp(buffer, diff, step(0.5, diff.r));

				return color;
			}
			ENDCG
		}
	}
	FallBack "Unlit/Transparent"
}
