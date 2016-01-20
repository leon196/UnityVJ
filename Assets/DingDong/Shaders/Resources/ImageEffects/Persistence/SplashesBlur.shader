Shader "Hidden/SplashesBlur" {
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
			sampler2D _TextureFFT;
			
			float _PersistenceTreshold;
			float _GlobalFFT;
			float _ReaktorOutput;

			half4 frag (v2f_img i) : COLOR
			{
				float2 uv = i.uv;

				float2 p = uv - float2(0.5, 0.5);
				p.x *= _ScreenParams.x / _ScreenParams.y;

				float dist = length(p);
				dist = pow(0.1 + dist * 6.0, 2.0);
				float angle = atan2(p.y, p.x);

				float lum = luminance(tex2D(_BufferTexture, uv));

				float fftAcceleration = _ReaktorOutput;

				float2 offset = float2(cos(angle), sin(angle)) * 0.002 * (1.0 + lum) * (0.1 + dist) * fftAcceleration;

				float random = cnoise(p * dist * 30.0);
				angle = random * PI2;
				offset += float2(cos(angle), sin(angle)) * 0.001 * fftAcceleration;

				half4 video = tex2D(_MainTex, uv);
				half4 renderTarget = cheesyBlur(_BufferTexture, uv - offset, _ScreenParams.xy);
				renderTarget.rgb *= 0.98;
				// half4 edge = filter(_MainTex, uv, _ScreenParams.xy);
				// half4 color = lerp(renderTarget, video, step(_PersistenceTreshold, luminance(abs(video - renderTarget))));
				// color = lerp(color, video, clamp(filter(_MainTex, uv, _ScreenParams.xy), 0.0, 1.0));
				half4 color = max(video, renderTarget);

				color.a = 1.0;
				color = clamp(color, 0.0, 1.0);

				return color;
			}
			ENDCG
		} 
	}
	FallBack "Unlit/Transparent"
}
