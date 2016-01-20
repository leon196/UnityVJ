Shader "Hidden/Waves" {
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

			half4 frag (v2f_img i) : COLOR {
				float2 uv = i.uv;

				float2 pixelSize = round(2.0 + 2.0 * (1.0 - _ReaktorOutput));
				uv = pixelize(uv, round(_ScreenParams.xy / pixelSize));

				fixed4 webcam = tex2D(_WebcamTexture, uv);
				// fixed4 diff = cheesyBlur(_DifferenceTexture, uv, _ScreenParams.xy);
				fixed4 diff = tex2D(_DifferenceTexture, uv);
				float lum = luminance(tex2D(_MainTex, uv).rgb);
				float unit = pixelSize / _ScreenParams.x;

				float2 offset = float2(0.0,0.0);//float2(1.0, 0.0) * unit * 4.0;
				float angle = cnoise(uv * 1000.0 + _Time) * PI;
				offset += float2(cos(angle), sin(angle)) * unit * _ReaktorOutput;

				angle = lum * PI2;// + _ReaktorOutput * PI2;
				offset += float2(cos(angle), sin(angle)) * unit * (1.0 + _ReaktorOutput * 4.0);

				// fixed4 buffer = cheesyBlur(_BufferTexture, uv + offset, _ScreenParams.xy);
				fixed4 buffer = tex2D(_BufferTexture, wrapUV(uv + offset));
				// buffer.rgb *= 0.99;

				fixed4 color = lerp(buffer, webcam, step(0.5, diff.r));

				return color;
			}
			ENDCG
		}
	}
	FallBack "Unlit/Transparent"
}
