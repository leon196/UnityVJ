Shader "DingDong/Basic/NormalColor" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Texture (RGB)", 2D) = "white" {}
	}
	SubShader {
		Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" }
		Pass {
			Cull off
			Blend SrcAlpha OneMinusSrcAlpha
			ZWrite Off
			LOD 200

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
        	#pragma target 3.0
			#include "UnityCG.cginc"

			struct v2f {
				float4 pos : SV_POSITION;
				float2 uv : TEXCOORD0;
				float4 normal : NORMAL;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			fixed4 _Color;

			v2f vert (appdata_full v)
			{
				v2f o;
				o.pos = mul (UNITY_MATRIX_MVP, v.vertex);
				o.uv = TRANSFORM_TEX (v.texcoord, _MainTex);
				o.normal = float4(v.normal, 1.0);
				return o;
			}

			half4 frag (v2f i) : COLOR
			{
				half4 color = half4(0.0, 0.0, 0.0, 1.0);
				color.rgb = i.normal * 0.5 + 0.5;
				return color;
			}
			ENDCG
		}
	}
	FallBack "Unlit/Transparent"
}
