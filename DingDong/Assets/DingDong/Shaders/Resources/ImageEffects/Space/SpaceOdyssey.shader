Shader "Hidden/SpaceOdyssey"
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
				float2 uv = i.uv.xy;
				uv -= float2(0.5, 0.5);
				uv.x *= _ScreenParams.x / _ScreenParams.y;
				uv.y /= uv.x;
				float t = _Time * uv.x * 10.0;
				// uv.x += lerp(t, -t, step(0.0, uv.x));
				fixed4 col = fixed4(1.0, 1.0, 1.0, 1.0);
				col.rgb *= step(fmod(abs(uv.x + t), 0.01), 0.005) * step(fmod(abs(uv.y), 0.2), 0.1);
				col.rgb *= abs(uv.x);
				return col;
			}
			ENDCG
		}
	}
}
