Shader "Morrowind/Morrowind4" {
  Properties {
    _Color ("Color", Color) = (1,1,1,1)
    _MainTex ("Texture (RGB)", 2D) = "white" {}
      _Size ("Size", Range(0, 1.0)) = 0.01
      _Scale ("Scale", Range(0, 1.0)) = 0.01
      _Offset ("Offset", Range(0, 1.0)) = 0.01
    }
    SubShader {
      Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" }
      Pass {
        Blend SrcAlpha OneMinusSrcAlpha
        LOD 200

        CGPROGRAM
        #pragma vertex vert
        #pragma geometry geom
        #pragma fragment frag
        #include "UnityCG.cginc"
        #include "../DingDong/Shaders/Complex.cginc"
        #include "../DingDong/Shaders/noise3D.cginc"
        #define PI 3.14159265

				struct GS_INPUT
				{
					float4 pos		: POSITION;
					float3 normal	: NORMAL;
					float2 uv	: TEXCOORD0;
          float4 screenUV : TEXCOORD1;
				};

        struct FS_INPUT {
          float4 pos : SV_POSITION;
          float2 uv : TEXCOORD0;
          float4 screenUV : TEXCOORD1;
          half4 color : COLOR;
          float3 normal : NORMAL;
        };

        sampler2D _MainTex;
        sampler2D _TextureFFT;
        float4 _MainTex_ST;
        fixed4 _Color;
        float _Size;
        float _Scale;
        float _Offset;

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

        float3 getTriangleNormal(float3 a, float3 b, float3 c)
        {
          float3 u = b - a;
          float3 v = c - a;
          float3 normal = float3(1.0, 0.0, 0.0);
          normal.x = u.y * v.z - u.z * v.y;
          normal.y = u.z * v.x - u.x * v.z;
          normal.z = u.x * v.y - u.y * v.x;
          return normalize(normal);
        }

        GS_INPUT vert (appdata_full v)
        {
          GS_INPUT o = (GS_INPUT)0;
          o.pos =  mul(_Object2World, v.vertex);
          o.normal = v.normal;
          o.uv = TRANSFORM_TEX (v.texcoord, _MainTex);
          o.screenUV = ComputeScreenPos(o.pos);
          return o;
        }

        [maxvertexcount(3)]
        void geom(triangle GS_INPUT tri[3], inout TriangleStream<FS_INPUT> triStream)
        {
          float3 a = tri[0].pos;
          float3 b = tri[1].pos;
          float3 c = tri[2].pos;
          float2 uvA = tri[0].uv;
          float2 uvB = tri[1].uv;
          float2 uvC = tri[2].uv;
          float3 g = (a + b + c) / 3.0;
          float3 triNormal = getTriangleNormal(a, b, c);
          float lum = Luminance(tex2Dlod(_MainTex, float4(uvA, 0.0, 0.0)));

  				float dist = length(g);
  				float t = _Time * 20.0;
  				float tt = cos(_Time * 30.0) * 0.5 + 0.5;
          /*float x = 1.0 - abs(fmod(abs(dist * 10.0 + t), 1.0) * 2.0 - 1.0);*/
          /*float x = 1.0 - abs(fmod(abs(g.y), 1.0) * 2.0 - 1.0);*/
          /*float x = ((triNormal.x + triNormal.y + triNormal.z) / 3.0) * 0.5 + 0.5;*/
          float x = (atan2(triNormal.y, triNormal.x) * 0.5 / PI + 0.5 + atan2(triNormal.z, triNormal.x) * 0.5 / PI + 0.5 ) / 2.0;
          float fft = tex2Dlod(_TextureFFT, float4(x, 0, 0, 0)).r;
  				float3 pos = g;//mul(_World2Object, v.vertex);
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
  				float n = dist + pos.y;// * 4.0;//snoise(pos * 0.1 + float3(0.0, t, 0.0)) * 0.5 + 0.5;
  				/*v.vertex.xyz += dir * n;*/
  				/*float3 pp = normalize(pos) * min(length(pos), 40.0 * tt);*/
  				/*v.vertex.xyz = pos + rotateY(v.normal, n + t) + rotateX(v.normal, n);*/

          // Scale
          /*a += normalize(a - g) * fft;
          b += normalize(b - g) * fft;
          c += normalize(c - g) * fft;*/

          float3 aa = lerp(a, g, 0.5);
          float3 bb = lerp(b, g, 0.5);
          float3 cc = lerp(c, g, 0.5);
          /*a = rotateY(a, fft * 10.0);
          b = rotateY(b, fft * 2.0);
          c = rotateY(c, fft * 5.0);*/
          /*a += triNormal * fft;// * 0.75;
          b += triNormal * fft;// * 1.0;*/
          c += triNormal * fft * (lum * 0.5 + 0.5);
          /*a = a + rotateY(tri[0].normal, n + t);// + rotateX(tri[0].normal, n);
          b = b + rotateY(tri[1].normal, n + t);// + rotateX(tri[1].normal, n);
          c = c + rotateY(tri[2].normal, n + t);// + rotateX(tri[2].normal, n);*/

          /*float tt = _Time * 3.0;
          float radius = 1.0;
          float angle = length(g) * t;
          a = rotateY(a, angle);
          b = rotateY(b, angle);
          c = rotateY(c, angle);*/

          float4x4 vp = mul(UNITY_MATRIX_MVP, _World2Object);

          triNormal = getTriangleNormal(a, b, c);

          FS_INPUT pIn = (FS_INPUT)0;
          pIn.pos = mul(vp, float4(a, 1.0));
          pIn.uv = tri[0].uv;
          pIn.normal = triNormal;
          pIn.color = half4(1.0,0.0,0.0,1.0);
          triStream.Append(pIn);

          pIn.pos =  mul(vp, float4(b, 1.0));
          pIn.uv = tri[1].uv;
          pIn.normal = triNormal;
          pIn.color = half4(0.0,1.0,0.0,0.0);
          triStream.Append(pIn);

          pIn.pos =  mul(vp, float4(c, 1.0));
          pIn.uv = tri[2].uv;
          pIn.normal = triNormal;
          pIn.color = half4(0.0,0.0,1.0,1.0);
          triStream.Append(pIn);
        }

        half4 frag (FS_INPUT i) : COLOR
        {
          half4 color = tex2D(_MainTex, i.uv);
          /*color.rgb = i.normal * 0.5 + 0.5;*/
          return color;
        }
        ENDCG
      }
    }
    FallBack "Unlit/Transparent"
  }
