Shader "distortImage" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		//_MaskTex ("Mask texture", 2D) = "white" {}
		//_maskBlend ("Mask blending", Float) = 0.5
		//_maskSize ("Mask Size", Float) = 1
		_deform ("deform Size", Float) = 1
		_gain ("gain", Float) = 1
	}
	SubShader {
		Pass {
			CGPROGRAM
			#pragma vertex vert_img
			#pragma fragment frag
			#include "UnityCG.cginc"
		
			uniform sampler2D _MainTex;
			//uniform sampler2D _MaskTex;
			
			//fixed _maskBlend;
			//fixed _maskSize;

			float _deform;
			float _gain;
 
			float4 frag(v2f_img i) : COLOR {
				//half2 n = tex2D(_DisplacementTex, i.uv);
				//half2 d = n * 2 -1;
				//i.uv += d * _Strength;
				//i.uv -= 0.5;

				float mask =  1 - min(sin(i.uv.y*3.14),sin(i.uv.x*3.14));
				mask *= 0.1;

				float lines = saturate (abs(sin((i.uv.y+_SinTime.x)*889)))/100 * mask;


				float d = sin(i.uv.y * 10 * _SinTime.x) / 50;

				d+= lines;

				float smallStuff = saturate (abs(sin(i.uv.y*7 * _SinTime.x))*10-9.99);

				d += smallStuff;

				d += saturate(abs(sin(i.uv.y * 11 )))/20;

				d+= 0.03;

				d +=( 1- saturate (abs(sin(i.uv.y*7.5 * _SinTime.x)+sin(i.uv.y*13.5))*8) )/40;

				//to delete d += 1- saturate (abs(sin(i.uv.y*11))*12);

				i.uv.y += saturate(d)/2 * _deform;

				//i.uv = pow(i.uv,_deform);
				//i.uv = saturate(i.uv);
				//i.uv += 0.5;



				i.uv += float2(i.uv.y * d * 0.1,0) ;
			 
				float4 c = tex2D(_MainTex, i.uv);

				float2 wOffset = float2(1/_ScreenParams.y,0);

				d = saturate(saturate(d-0.1)*100);

				float4 blurred = 0;
				for (int j=-5; j<5; j++){
					 blurred.r += tex2D(_MainTex, i.uv + float2(j/_ScreenParams.x,0) );
					 blurred.g += tex2D(_MainTex, i.uv + float2(j/_ScreenParams.x,0) + d*4*wOffset);
					 blurred.b += tex2D(_MainTex, i.uv + float2(j/_ScreenParams.x,0) + d*8*wOffset);
				}
				blurred/= +10;


				//c += tex2D(_MainTex, i.uv);



				c = lerp(c,blurred,abs(d));

				c = lerp(c,blurred,saturate(smallStuff*10));

				d *= 5;
							
				//c.g = tex2D(_MainTex, i.uv+float2(d/_ScreenParams.y,0));
				//c.b = tex2D(_MainTex, i.uv+float2(d*2/_ScreenParams.y,0));

				float wtf = tex2D(_MainTex, pow(i.uv,d));

				c = lerp(c,tex2D(_MainTex, i.uv+float2(_ScreenParams.z,0)),0.1*mask);

				c += wtf * mask / 5;
				
				c *= _gain;

				return c * 1-lines*30;	

						
					
			}
			ENDCG
		}
	}
}