Shader "Hidden/Gradient"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_ColorA ("Color A", Color) = (1,1,1,1)
		_ColorB ("Color B", Color) = (1,1,1,1)
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
			#include "../../Utils/ClassicNoise2D.cginc"
			#include "../../Utils/Utils.cginc"

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
			fixed4 _ColorA;
			fixed4 _ColorB;
			fixed4 _ColorC;

			fixed4 frag (v2f i) : SV_Target
			{
				half4 color = tex2D(_MainTex, i.uv);

				float lum = Luminance(color);
				color.rgb = lerp(_ColorA, _ColorB, smoothstep(0.0, 0.5, lum));
				color.rgb = lerp(color.rgb, _ColorC, smoothstep(0.5, 1.0, lum));

				return color;
			}
			ENDCG
		}
	}
}
