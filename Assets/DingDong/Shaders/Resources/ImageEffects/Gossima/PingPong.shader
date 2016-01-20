Shader "Hidden/PingPong" {
	Properties 	{
		_MainTex ("Texture", 2D) = "white" {}
	}
	SubShader 	{
		Cull Off ZWrite Off ZTest Always
		Pass 		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"
			#include "../../Utils/Utils.cginc"
			
			struct appdata {
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f {
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			v2f vert (appdata v) {
				v2f o;
				o.vertex = mul(UNITY_MATRIX_MVP, v.vertex);
				o.uv = v.uv;
				return o;
			}
			
			sampler2D _MainTex;
			sampler2D _BufferTexture;
			sampler2D _DifferenceTexture;
			sampler2D _ParticleTexture;
			float _ReaktorOutput;
			float _FadeOutRatio;

			fixed4 frag (v2f i) : SV_Target {
				float2 uv = i.uv;
				float2 webcamUV = uv;
				webcamUV.x = 1.0 - webcamUV.x;
				fixed4 tex = tex2D(_MainTex, webcamUV);
				fixed4 diff = tex2D(_DifferenceTexture, webcamUV);
				fixed4 particle = tex2D(_ParticleTexture, webcamUV);
				fixed4 buffer = tex2D(_BufferTexture, uv);
				buffer.rgb *= _FadeOutRatio;
				buffer = clamp(buffer + diff, 0.0, 1.0);
				fixed4 color = lerp(buffer, particle, step(0.5, particle));
				return color;
			}
			ENDCG
		}
	}
}
