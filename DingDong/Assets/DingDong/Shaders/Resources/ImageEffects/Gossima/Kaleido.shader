Shader "Hidden/Kaleido"
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
			#pragma target 3.0

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
			float _OhoSlider1;
			float _OhoSlider2;
			float _KaleidoCount;

			fixed4 frag (v2f i) : SV_Target
			{
				float2 uv = i.uv;
				float t = _Time * 4;

				float2 center = uv - float2(0.5, 0.5);
				center.x *= _ScreenParams.x / _ScreenParams.y;
				float angle = (atan2(center.y, center.x) / PI) * _KaleidoCount;
				float dist = length(center) * 4 * (1 + _OhoSlider2 * 4) - t;
				uv.x = kaleido(angle, 0);
				uv.y = kaleido(dist, 0);

				fixed4 col = tex2D(_MainTex, uv);
				return col;
			}
			ENDCG
		}
	}
}
