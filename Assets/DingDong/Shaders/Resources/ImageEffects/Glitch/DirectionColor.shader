Shader "Hidden/DirectionColor"
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
			float _ReaktorOutput;

			fixed4 frag (v2f i) : SV_Target
			{
				float2 uv = i.uv;

				// uv = pixelize(uv, 256.0);

				float2 center = float2(0.5, 0.5) - uv;
				float angle = atan2(center.y, center.x);
				float dist = length(center);
				dist = pow(0.1 + dist * 6.0, 2.0) ;

				float fftAcceleration = _ReaktorOutput;

				float2 offset = float2(cos(angle) * dist, sin(angle) * dist) * 0.004 * fftAcceleration;
				angle = rand(uv) * PI2;
				offset += float2(cos(angle), sin(angle)) * 0.002 * fftAcceleration;

				angle = luminance(tex2D(_MainTex, uv).rgb) * PI2;
				offset += float2(cos(angle), sin(angle)) * 0.006 * fftAcceleration;

				half4 video = tex2D(_MainTex, uv);
				half4 renderTarget = tex2D(_BufferTexture, uv + offset);

				half4 color = lerp(renderTarget, video, step(fftAcceleration, distance(video.rgb, renderTarget.rgb)));

				return color;
			}
			ENDCG
		}
	}
}
