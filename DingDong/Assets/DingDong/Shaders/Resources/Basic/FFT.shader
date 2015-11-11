Shader "DingDong/Basic/FFT" {
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
				#include "UnityCG.cginc"

				struct v2f {
					float4 pos : SV_POSITION;
					float2 uv : TEXCOORD0;
				};

				sampler2D _MainTex;
				sampler2D _TextureFFT;
				float4 _MainTex_ST;
				fixed4 _Color;

				v2f vert (appdata_full v)
				{
					v2f o;
					o.pos = mul (UNITY_MATRIX_MVP, v.vertex);
					o.uv = TRANSFORM_TEX (v.texcoord, _MainTex);
					return o;
				}

				half4 frag (v2f i) : COLOR
				{
					half4 tex = tex2D(_TextureFFT, i.uv);
					half4 red = half4(1, 0, 0, 1);
					float lin = i.uv.y - tex.r;
					//half4 color = lerp(tex, red, 0.01 / abs(lin));
					half4 color = red * 0.01 / abs(lin);
					return color;
				}

				ENDCG
			}
		}
		FallBack "Unlit/Transparent"
	}
