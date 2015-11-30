Shader "Hidden/DirectionColor"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_PersistenceTreshold ("Persistence Treshold", Range(0, 1)) = 0.5
	}
	SubShader
	{
		// No culling or depth
		Cull Off ZWrite Off ZTest Always

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			#include "../../Utils/Utils.cginc"
			#include "../../Utils/Easing.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = mul(UNITY_MATRIX_MVP, v.vertex);
				o.uv = v.uv;
				return o;
			}
			
			sampler2D _MainTex;
			sampler2D _BufferTexture;
			sampler2D _TextureFFT;
			sampler2D _TextureFFTPoint;
			float _GlobalFFT;
			float _GlobalFFTTotal;
			float _PersistenceTreshold;

			fixed4 frag (v2f i) : SV_Target
			{
				float2 uv = i.uv;

				// uv = pixelize(uv, 256.0);

				float2 center = float2(0.5, 0.5) - uv;
				float angle = atan2(center.y, center.x);
				float dist = length(center);

				float t = _Time * 20.0;
				float tt = cos(_Time * 30.0) * 0.5 + 0.5;
				float x = fmod(((angle / PI) * 0.5 + 0.5) + _GlobalFFTTotal * 0.001, 1.0);
				float fft = tex2Dlod(_TextureFFT, float4(x, 0, 0, 0)).r;

				dist = pow(0.1 + dist * 6.0, 2.0) ;

				float fftAcceleration = 0.5 + _GlobalFFT * 0.5;//clamp((fft + _GlobalFFT) * 0.5, 0.0, 1.0);//(0.1 + pow(fft, 2.0) * 0.5 + pow(_GlobalFFT, 2.0));

				float2 offset = float2(cos(angle) * dist, sin(angle) * dist) * 0.008 * fftAcceleration;
				angle = rand(uv) * PI2;
				offset += float2(cos(angle), sin(angle)) * 0.001 * fftAcceleration;

				angle = luminance(tex2D(_MainTex, uv).rgb) * PI2;
				offset += float2(cos(angle), sin(angle)) * 0.01 * fftAcceleration;

				half4 video = tex2D(_MainTex, uv);
				half4 renderTarget = tex2D(_BufferTexture, uv + offset);

				renderTarget *= 0.99 + fftAcceleration * 0.04;
				// float treshold = 0.2 + fftAcceleration * 0.8;
				// float treshold = easeOutQuint(_GlobalFFT, 0.0, 1.0, 1.0);
				half4 color = lerp(renderTarget, video, step(_PersistenceTreshold, distance(video.rgb, renderTarget.rgb)));
    			// color = lerp(color, video, clamp(luminance(filter(_MainTex, uv, _ScreenParams.xy)), 0.0, 1.0));
				//distance(video.rgb, renderTarget.rgb)
				//Luminance(abs(video - renderTarget))

				return color;
			}
			ENDCG
		}
	}
}
