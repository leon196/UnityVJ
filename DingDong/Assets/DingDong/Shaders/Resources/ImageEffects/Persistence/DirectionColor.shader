Shader "Hidden/DirectionColor"
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
			
			#include "UnityCG.cginc"
			#define PI 3.141592653589
			#define PI2 6.283185307179

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

			float2 pixelate (float2 p, float detail)
			{
				return floor(p * detail) / detail;
			}

			float luminance (float3 c)
			{
				return (c.r + c.g + c.b) / 3.0;
			}

			// http://stackoverflow.com/questions/12964279/whats-the-origin-of-this-glsl-rand-one-liner
			float rand(float2 co)
			{
			  return frac(sin(dot(co.xy ,float2(12.9898,78.233))) * 43758.5453);
			}
			
			sampler2D _MainTex;
			sampler2D _BufferTexture;
			sampler2D _TextureFFT;
			float _GlobalFFT;

			fixed4 frag (v2f i) : SV_Target
			{
				float2 uv = i.uv;

				// uv = pixelate(uv, 256.0);

				float2 center = float2(0.5, 0.5) - uv;
				float angle = atan2(center.y, center.x);
				float dist = length(center);

				float t = _Time * 20.0;
				float tt = cos(_Time * 30.0) * 0.5 + 0.5;
				float x = (angle / PI) * 0.5 + 0.5;
				// float x = 1.0 - abs(fmod(abs(dist * 10.0 + t), 1.0) * 2.0 - 1.0);
				// float x = 1.0 - abs(fmod(abs(g.y), 1.0) * 2.0 - 1.0);
				// float x = ((triNormal.x + triNormal.y + triNormal.z) / 3.0) * 0.5 + 0.5;
				// float x = (atan2(triNormal.y, triNormal.x) * 0.5 / PI + 0.5 + atan2(triNormal.z, triNormal.x) * 0.5 / PI + 0.5 ) / 2.0;
				// float x = clamp(g.y / 2.0, 0.0, 1.0);
				// float x = (atan2(triNormal.y, triNormal.x) / PI) * 0.5 + 0.5;
				// float x = 1.0 - dot(normalize(WorldSpaceViewDir(float4(g, 1.0))), triNormal) * 0.5 + 0.5;
				float fft = tex2Dlod(_TextureFFT, float4(x, 0, 0, 0)).r;

				float2 offset = float2(cos(angle) * dist, sin(angle) * dist) * 0.1 * (0.1 + _GlobalFFT * 2.0);
				angle = rand(uv) * PI2;
				offset += float2(cos(angle), sin(angle)) * 0.002;

				half4 video = tex2D(_MainTex, uv);
				half4 renderTarget = tex2D(_BufferTexture, uv + offset);

				// renderTarget *= 1.0 + (_GlobalFFT * 0.5);
				float treshold = 0.5;//_GlobalFFT * 0.8 + 0.2;
				half4 color = lerp(renderTarget, video, step(treshold, Luminance(abs(video - renderTarget))));
				//distance(video.rgb, renderTarget.rgb)
				//Luminance(abs(video - renderTarget))

				return color;
			}
			ENDCG
		}
	}
}
