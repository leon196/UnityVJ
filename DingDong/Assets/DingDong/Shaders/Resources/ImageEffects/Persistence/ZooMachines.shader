Shader "Hidden/ZooMachines"
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
			#pragma target 3.0
			
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
			sampler2D _TextureFFT;
			float _GlobalFFT;

			fixed4 frag (v2f i) : SV_Target
			{
				float2 uv = i.uv;
			    
			    // Pixelate
			   	// uv = pixelate(uv, _ScreenParams.xy / 4.0);
			    
			    // Maths infos about the current pixel position
			    float2 center = uv - float2(0.5, 0.5);
			    float angle = atan2(center.y, center.x);
			    float radius = length(center);
			    float ratioAngle = (angle / PI) * 0.5 + 0.5;
			    
			    // Displacement from noise
			    float2 angleUV = fmod(abs(float2(0, angle / PI)), 1.0);
			    float offset = (cnoise((angleUV + _GlobalFFT) * 40.0) * 0.5 + 0.5) * 0.75;
			    
			    // Displaced pixel color
			    float2 p = float2(cos(angle), sin(angle)) * offset + float2(0.5, 0.5);
			    
			    // Apply displacement
			    uv = lerp(uv, p, step(offset, radius));

				half4 color = tex2D(_MainTex, uv);
				// half4 buffer = tex2D(_BufferTexture, uv + offset);

			    // Treshold color from luminance
			    // float lum = luminance(color);    
			    // color.rgb = lerp(float3(0,0,0), float3(1,0,0), step(0.45, lum));
			    // color.rgb = lerp(color.rgb, float3(1,1,0), step(0.65, lum));
			    // color.rgb = lerp(color.rgb, float3(1,1,1), step(0.85, lum));

				// buffer *= 1.0 + (_GlobalFFT * 0.5);
				float treshold = 0.5;//_GlobalFFT * 0.8 + 0.2;
				// half4 color = lerp(buffer, texture, step(treshold, Luminance(abs(texture - buffer))));
				//distance(texture.rgb, buffer.rgb)
				//Luminance(abs(texture - buffer))

				return color;
			}
			ENDCG
		}
	}
}
