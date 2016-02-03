Shader "colorCorrect" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_gain ("gain", Float) = 1
		_gamma ("gamma", Float) = 1
		_black ("black point", Float) = 0		
	}
	SubShader {
		Pass {
			CGPROGRAM
			#pragma vertex vert_img
			#pragma fragment frag
			#include "UnityCG.cginc"
		
			uniform sampler2D _MainTex;

			float _gamma;
			float _gain;
			float _black;
 
			float4 frag(v2f_img i) : COLOR{	
					
				float4 c = tex2D(_MainTex, i.uv);				
				
				c = pow(c, _gamma);
				c -= _black;
				c *= _gain;
								
				return c ;	
			}
			ENDCG
		}
	}
}