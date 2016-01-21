Shader "Hidden/WireframeFilter" {
	Properties {
		_MainTex ("Texture", 2D) = "white" {}
	}
	SubShader {
		Cull Off ZWrite Off ZTest Always
		Pass {
			CGPROGRAM
			#pragma vertex vert_img
			#pragma fragment frag
			#include "UnityCG.cginc"
			
			sampler2D _MainTex;
			sampler2D _WireframeTexture;

			fixed4 frag (v2f_img i) : SV_Target {
				return tex2D(_WireframeTexture, i.uv);
			}
			ENDCG
		}
	}
}
