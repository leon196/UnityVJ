Shader "Morrowind/Morrowind9" {
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
        Cull off
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
          half4 color : COLOR;
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
        float _GlobalFFTTotal;

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

        float vec3ToFloatWay1 (float3 v)
        {
          return ((v.x + v.y + v.z) / 3.0) * 0.5 + 0.5;;
        }

        float vec3ToFloatWay2 (float3 v)
        {
          return (atan2(v.y, v.x) * 0.5 / 3.14159265 + 0.5 + atan2(v.z, v.x) * 0.5 / 3.14159265 + 0.5 ) / 2.0;
        }

        GS_INPUT vert (appdata_full v)
        {
          GS_INPUT o = (GS_INPUT)0;
          o.pos =  mul(_Object2World, v.vertex);
          o.normal = v.normal;
          o.uv = TRANSFORM_TEX (v.texcoord, _MainTex);
          o.color = v.color;
          o.screenUV = ComputeScreenPos(o.pos);
          return o;
        }

        [maxvertexcount(3)]
        void geom(triangle GS_INPUT tri[3], inout TriangleStream<FS_INPUT> triStream)
        {
          float3 a = tri[0].pos;
          float3 b = tri[1].pos;
          float3 c = tri[2].pos;
          float3 g = (a + b + c) / 3.0;
          float3 triNormal = getTriangleNormal(a, b, c);
          float x = (atan2(triNormal.y, triNormal.x) * 0.5 / PI + 0.5 + atan2(triNormal.z, triNormal.x) * 0.5 / PI + 0.5 ) / 2.0;

  				float dist = length(g);
  				float t = _Time * 20.0;
  				float tt = cos(_Time * 30.0) * 0.5 + 0.5;
          float ttt = fmod(t*0.5 + _Offset + x, 1.0);

          float fft = tex2Dlod(_TextureFFT, float4(x, 0, 0, 0)).r;

          float tttt = smoothstep(0.0, 1.0, ttt);
          a = lerp(a, g, tttt);
          b = lerp(b, g, tttt);
          c = lerp(c, g, tttt);

          float r = _Offset + tttt * 0.1 + (dist * 20.0);
          a = (a - tri[0].pos) + rotateY(tri[0].pos, r);
          b = (b - tri[1].pos) + rotateY(tri[1].pos, r);
          c = (c - tri[2].pos) + rotateY(tri[2].pos, r);
          //a = rotateY(a, _Offset + _GlobalFFTTo   tal * 0.1 + pow(dist / 10.0, 2.0));
          //b = rotateY(b, _Offset + _GlobalFFTTotal * 0.1 + pow(dist / 10.0, 2.0));
          //c = rotateY(c, _Offset + _GlobalFFTTotal * 0.1 + pow(dist / 10.0, 2.0));
          a += triNormal * ttt;// + triNormal * (fft);
          b += triNormal * ttt;// + triNormal * (fft);
          c += triNormal * ttt;// + triNormal * (fft);

          float4 color = float4(1.0, 1.0, 1.0, 1.0);
          color.rgb *= ttt;

          float4x4 vp = mul(UNITY_MATRIX_MVP, _World2Object);

          FS_INPUT pIn = (FS_INPUT)0;
          pIn.pos = mul(vp, float4(a, 1.0));
          pIn.uv = tri[0].uv;
          pIn.normal = tri[0].normal;
          pIn.color = color;
          triStream.Append(pIn);

          pIn.pos =  mul(vp, float4(b, 1.0));
          pIn.uv = tri[1].uv;
          pIn.normal = tri[1].normal;
          pIn.color = color;
          triStream.Append(pIn);

          pIn.pos =  mul(vp, float4(c, 1.0));
          pIn.uv = tri[2].uv;
          pIn.normal = tri[2].normal;
          pIn.color = color;
          triStream.Append(pIn);
        }

        half4 frag (FS_INPUT i) : COLOR
        {
          half4 color = tex2D(_MainTex, i.uv);
          /*color.rgb = lerp(color.rgb, float3(1.0, 1.0, 1.0), sqrt(i.color.r));*/
          //color.a *= 1.0 - i.color.r;
          //color.a *= 0.5;
          return color;
        }
        ENDCG
      }
    }
    FallBack "Unlit/Transparent"
  }
