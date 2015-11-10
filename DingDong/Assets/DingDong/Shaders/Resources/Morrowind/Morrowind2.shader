Shader "Morrowind/Morrowind2"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			// make fog work
			#pragma multi_compile_fog

			#include "UnityCG.cginc"
			#include "../Utils/Complex.cginc"
			#include "../Utils/Noise3D.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
				float3 normal : NORMAL;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				UNITY_FOG_COORDS(1)
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			uniform sampler2D _TextureFFT;

			float3 rotateY(float3 v, float t)
			{
				float cost = cos(t); float sint = sin(t);
				return float3(v.x * cost + v.z * sint, v.y, -v.x * sint + v.z * cost);
			}

			float3 rotateX(float3 v, float t)
			{
				float cost = cos(t); float sint = sin(t);
				return float3(v.x, v.y * cost - v.z * sint, v.y * sint + v.z * cost);
			}

			v2f vert (appdata v)
			{
				v2f o;

				float dist = length(v.vertex);
				float t = _Time * 20.0;
				float tt = cos(_Time * 10.0) * 0.5 + 0.5;
        /*float x = 1.0 - abs(fmod(abs(dist * 10.0 + t), 1.0) * 2.0 - 1.0);*/
        float x = ((v.normal.x + v.normal.y + v.normal.z) / 3.0) * 0.5 + 0.5;
        float fft = tex2Dlod(_TextureFFT, float4(x, 0, 0, 0)).r;
				float3 pos = mul(_World2Object, v.vertex);
				/*pos = rotateY(pos, t);*/
				float radius = length(pos.xyz);
				float3 dir = normalize(pos.xyz);
				/*dir = rotateY(dir, t);*/
				float angle = atan2(dir.z, dir.x);
        float2 p = float2(radius, angle);
				p = complex_mul(p, p);
				/*v.vertex.xyz += normalize(pos) * p.x;*/
				/*v.vertex.xyz = rotateY(v.vertex.xyz, p.x * 0.001);*/
				/*dist = 1.0 * cos(fft * 3.1416) / ((dist * 0.1) + 2.0);*/
				/*v.vertex.xyz += normalize(normalize(pos) + v.normal) * dist;*/
				dir = normalize(float3(-1.0, 2.0, -1.0));
				float n = dist;// * 4.0;//snoise(pos * 0.1 + float3(0.0, t, 0.0)) * 0.5 + 0.5;
				/*v.vertex.xyz += dir * n;*/
				/*float3 pp = normalize(pos) * min(length(pos), 40.0 * tt);*/
				v.vertex.xyz = pos + rotateY(v.normal, n + t) + rotateX(v.normal, n);
				/*v.vertex.xyz += normalize(pos) * dist;*/
				/*v.vertex.xz = (pos + v.normal * p.y * tt).xz;// + v.normal * fft;*/
				o.vertex = mul(UNITY_MATRIX_MVP, v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}

			fixed4 frag (v2f i) : SV_Target
			{
				// sample the texture
				fixed4 col = tex2D(_MainTex, i.uv);
				// apply fog
				UNITY_APPLY_FOG(i.fogCoord, col);
				return col;
			}
			ENDCG
		}
	}
}
