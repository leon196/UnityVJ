Shader "Hidden/Splashes"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_Speed ("Speed", Range(0.01, 1.0)) = 0.5
		_DirectionColorRatio ("Color Direction Ratio", Range(0, 1.0)) = 0
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
			#pragma target 3.0

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
			sampler2D _WebcamTexture;
			sampler2D _BufferTexture;
			float _GlobalFFT;
			float _Speed;
			float _DirectionColorRatio;

			fixed4 frag (v2f i) : SV_Target
			{
				float2 uv = i.uv;
				float2 center = float2(0.5, 0.5) - uv;
				float angle = atan2(center.y, center.x);
				float dist = length(center);
				dist = pow(0.1 + dist * 6.0, 2.0);

				float fftAcceleration = clamp(_Speed + _GlobalFFT, 0, 1);
				float2 offset = float2(cos(angle) * dist, sin(angle) * dist) * 0.01 * fftAcceleration;
				float rnd = rand(uv) * PI;
				offset += float2(cos(rnd), sin(rnd)) * 0.002 * fftAcceleration;

				half4 video = tex2D(_WebcamTexture, uv);

				angle = Luminance(video) * PI2;
				offset += _DirectionColorRatio * float2(cos(angle), sin(angle)) * 0.01;

				half4 renderTarget = tex2D(_BufferTexture, uv + offset);
				renderTarget *= 0.99;
				// renderTarget *= 0.99 + fftAcceleration * 0.02;
				// half4 color = lerp(video, renderTarget, step(0.15, distance(video.rgb, renderTarget.rgb)));
				// half4 color = lerp(video, renderTarget, step(0.5, luminance(abs(video.rgb - renderTarget.rgb))));
				// half4 color = lerp(video, renderTarget, fftAcceleration);
				// half4 color = lerp(video, renderTarget, smoothstep(0.25, 0.75, fftAcceleration) * 0.9);
				// half4 color = lerp(video, renderTarget, step(1 - fftAcceleration, distance(video.rgb, renderTarget.rgb)));
				// half4 color = clamp(video - renderTarget, 0.0, 1.0);
				half4 color = max(video, renderTarget);
				return color;
			}
			ENDCG
		}
	}
}
