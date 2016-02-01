Shader "Hidden/SpaceOdyssey"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_Horizontal ("Horizontal", Float) = 1
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
			float _Horizontal;

			fixed4 frag (v2f i) : SV_Target
			{
				float2 uv = i.uv.xy;
				uv -= float2(0.5, 0.5);
				uv.x *= _ScreenParams.x / _ScreenParams.y;
				float dist = length(uv.xx);
				float t = _Time * 10.0;
				t = lerp(-t, t, step(0.0, uv.x));
				// uv.x /= 100.0;
				// uv.y /= sqrt(abs(uv.x));
				// uv.y /= pow(abs(uv.x), 2.0);
				uv.y /= abs(uv.x);
				fixed4 col = fixed4(1.0, 1.0, 1.0, 1.0);
				// col.rgb *= step(fmod(abs(uv.x + t), 0.01), 0.005) * step(fmod(abs(uv.y), 0.2), 0.1);
				// col.rg = frac(uv);
				// uv.x -= t;
				float2 uvFinal = uv;
				// uvFinal.x /= sqrt(abs(uv.x));
				uvFinal.x /= pow(abs(uv.x), 2.0) * 40.0;
				uvFinal.x = kaleido(uvFinal.x, -t);
				uvFinal.y = kaleido(uvFinal.y, 0);
				uvFinal = wrapUV(uvFinal);
				col = tex2D(_MainTex, uvFinal);
				// col.rgb *= 1.0 - easeInExpo(1.0 - min(1.0, abs(uv.x)), 0.0, 1.0, 1.0);
				// col.rgb += easeInExpo(1.0 - min(1.0, abs(uv.x)), 0.0, 1.0, 1.0);
				return col;
			}
			ENDCG
		}
	}
}
