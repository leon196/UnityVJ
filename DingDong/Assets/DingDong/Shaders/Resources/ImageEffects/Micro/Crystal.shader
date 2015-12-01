Shader "Hidden/Crystal"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
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
			#include "../../Utils/ClassicNoise2D.cginc"

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

			fixed4 frag (v2f i) : SV_Target
			{
				float2 uv = i.uv;
				float t1 = _Time * 40.0;
				float t2 = _Time * 20.0;
				float lum = luminance(tex2D(_MainTex, uv).rgb);

				float2 center = float2(0.5, 0.5) - uv;
				center.x *= _ScreenParams.x / _ScreenParams.y;
				float angle = atan2(center.y, center.x);
				float dist = length(center);
				center = float2(cos(angle), sin(angle)) * dist;
				angle = atan2(center.y, center.x);
				dist = length(center);

			    // Displacement from noise
			    float seed = cnoise(float2((segment((angle / PI) * 0.5 + 0.5, 32.0) + _GlobalFFT * 0.05) * 40.0, 0.0)) * 0.5 + 0.5;
			    float offset = seed * 0.75;
			    float2 p = float2(cos(angle), sin(angle)) * offset + float2(0.5, 0.5);
				float lumDisp = luminance(tex2D(_MainTex, p).rgb);
			    
			    // Apply displacement
			    float2 uvDisp = lerp(uv, p, step(offset, dist));

				float fft = tex2Dlod(_TextureFFT, float4(lum, 0, 0, 0)).r;

				float mini = length(p - float2(0.5, 0.5));//min(length(center), length(p - float2(0.5, 0.5)));
				float treshold = smoothstep(mini, mini + 0.1, dist) * lumDisp * (1.0 - (cos(angle * 32.0) * 0.5 + 0.5));
				half4 color = lerp(tex2D(_MainTex, uv), tex2D(_MainTex, uvDisp), treshold);
				 // * smoothstep(length(uvDisp - p), 1.0, length(p)));
				// color.rgb = lerp(float3(0.0,0.0,0.0), color.rgb, fft);
				// color.rgb = lerp(float3(0.0,0.0,0.0), color.rgb, step(lum, _GlobalFFT));
				return color;
			}
			ENDCG
		}
	}
}
