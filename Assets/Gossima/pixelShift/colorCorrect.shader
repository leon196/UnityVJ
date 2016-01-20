Shader "colorCorrect" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_gain ("gain", Float) = 1
		_gamma ("gamma", Float) = 1
		_black ("black point", Float) = 0
		_white ("white point", Float) = 1
		_saturation ("saturation", Float) = 1
		
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
			float _white;	
			float _saturation;		
 
			float4 frag(v2f_img i) : COLOR {	
					
				float4 c = tex2D(_MainTex, i.uv);
				
				c = saturate( (c-_black)/_white ) ;
				c *= _gain;
				c = pow(c, _gamma);
				
				float middle =( c.r + c.g + c.b )/3;
				float4 diff = float4(c.r-middle,c.g-middle,c.b-middle,1);
				
				c -= diff;
				c += diff * _saturation;
				
				return c ;	
			}
			ENDCG
		}
	}
}