Shader "Hidden/Carpet"
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
			#include "../../Utils/Utils.cginc"
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

			fixed4 frag (v2f i) : SV_Target
			{
				float2 uv = i.uv;
				float t = _Time * 20.0;
				float shouldDistord = smoothstep(0.5, 1, 1 - i.uv.y);
				// float distortion = lerp(1, pow(i.uv.y + 0.5, 2), shouldDistord);
				float distortion = 1 - smoothstep(0.25, 0.65, 1.0 - i.uv.y) * 0.15;
				distortion *= 1 - smoothstep(0.65, 0.9, 1.0 - i.uv.y) * 0.75;
				// float noiseY = pow(cnoise(i.uv.yy * 0.5 + float2(0, t)), 2) * 2.0;
				// float noiseX = 0.5 + 0.5 * cnoise(float2(noiseY, noiseY) * 4.0);
				// float noiseY = cnoise(uv.yy * 15.0 + float2(0, t));
				// float noiseX = cnoise(uv.xx * 2.0);
				float noise = noiseIQ(float3(uv.x * 20, uv.y * 10.0, t));
				uv.y = min(1.0 - i.uv.y, 0.5);
				uv.x -= 0.5;
				uv.x *= 1 + shouldDistord * noise;
				uv.x *= distortion;
				uv.x += 0.5;
				float shouldDraw = clamp(step(0.1, uv.x) - step(uv.y, 0.1) - step(0.9, uv.x), 0, 1);
				// shouldDraw *= step(0.5, noise * 0.5 + 0.5);
				uv.y -= _Time * 2;

				float osc = sin(_Time * 10.0) * 0.5 + 0.5;
				uv.y *= 2;
				uv *= 0.5;
				uv = wrapUV(uv);
				fixed4 carpet = tex2D(_MainTex, uv);
				float shade = 0.6;
				carpet.rgb *= 1 - smoothstep(0.3, 0.6, 1.0 - i.uv.y) * shade + smoothstep(0.6, 0.8, 1.0 - i.uv.y) * shade;
				carpet.rgb *= 1 - smoothstep(0.8, 1.0, 1.0 - i.uv.y) * shade;
				carpet.rgb *= shouldDraw;
				return carpet;
			}
			ENDCG
		}
	}
}
