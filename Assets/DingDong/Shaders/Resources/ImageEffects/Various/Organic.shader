Shader "Hidden/Organic"
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
			#include "../../Utils/Utils.cginc"
			#include "../../Utils/Easing.cginc"
			#include "../../Utils/ClassicNoise2D.cginc"

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
			sampler2D _TextureFFTPoint;
			float _GlobalFFT;
			float _GlobalFFTTotal;

			fixed4 frag (v2f i) : SV_Target
			{
				float2 uv = i.uv;
				float lum = luminance(tex2D(_MainTex, uv).rgb);

				float2 center = float2(0.5, 0.5) - uv;
				float angle = atan2(center.y, center.x);
				float dist = length(center);

				float fft = tex2Dlod(_TextureFFT, float4(lum, 0, 0, 0)).r;

				float angleLum = lum * PI2;
				float2 offset = float2(cos(angleLum), sin(angleLum)) * (fft + _GlobalFFT) * 0.005 * lum;
				uv += offset;

				half4 color = tex2D(_MainTex, uv);

				// color.rgb = lerp(float3(0.0,0.0,0.0), color.rgb, fft);
				// color.rgb = lerp(float3(0.0,0.0,0.0), color.rgb, step(lum, _GlobalFFT));

				return color;
			}
			ENDCG
		}
	}
}
