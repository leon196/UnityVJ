Shader "Hidden/GlitchCyberBW" {
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
			sampler2D _WebcamTexture;
			sampler2D _DifferenceTexture;
			float _ReaktorOutput;

			half4 frag (v2f_img i) : COLOR
			{
				float2 uv = i.uv;
				fixed4 tex = tex2D(_MainTex, uv);
				fixed4 diff = tex2D(_DifferenceTexture, uv);
				float unit = 10.0 / _ScreenParams.x;

				float2 pixelSize = _ScreenParams.xy / 32.0;
				pixelSize.x *= _ScreenParams.x / _ScreenParams.y;
				float2 seed = pixelize(uv, pixelSize) * 10.0;
				float2 offset = float2(cnoise(seed), 0.0) * unit;//cnoise(tex.rg));

				fixed4 webcam = tex2D(_WebcamTexture, uv);
				fixed4 buffer = tex2D(_BufferTexture, wrapUV(uv + offset));
				fixed4 color = lerp(buffer, diff, step(0.5, diff));

				return color;
			}
			ENDCG
		}
	}
	FallBack "Unlit/Transparent"
}
