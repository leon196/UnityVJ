Shader "Warband/TriangleBeat" {
  Properties {
    _Color ("Color", Color) = (1,1,1,1)
    _MainTex ("Texture (RGB)", 2D) = "white" {}
      _Size ("Size", Range(0, 1.0)) = 0.01
    }
    SubShader {
      Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" }
      Pass {
        Blend SrcAlpha OneMinusSrcAlpha
        LOD 200
        Cull Off

        CGPROGRAM
        #pragma vertex vert
        #pragma fragment frag
        #pragma target 3.0
        #include "UnityCG.cginc"

        struct GS_INPUT
        {
          float4 pos		: POSITION;
          float4 normal	: NORMAL;
          float2 uv	: TEXCOORD0;
          float4 screenUV : TEXCOORD1;
          float4 color : COLOR;
        };

        struct FS_INPUT {
          float4 pos : SV_POSITION;
          float2 uv : TEXCOORD0;
          float4 screenUV : TEXCOORD1;
          half4 color : COLOR;
          float4 normal : NORMAL;
        };

        sampler2D _MainTex;
        sampler2D _TextureFFT;
        float4 _MainTex_ST;
        fixed4 _Color;
        float _Size;
        float _GlobalFFT;

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


        GS_INPUT vert (appdata_full v)
        {
          GS_INPUT o = (GS_INPUT)0;
          float3 position = mul(_Object2World, v.vertex).xyz;
          float t = cos(_Time * 10.0) * 0.5 + 0.5;
          float tt = _Time * 10.0;
          float radius = 5.0;
          float3 target = float3(cos(tt) * radius, 0.0, sin(tt) * radius);
          float dist = (length(position));
          /*float n = ((v.normal.x + v.normal.y + v.normal.z) / 3.0) * 0.5 + 0.5;*/
          float n = sin(dist * 0.1) * 0.5 + 0.5;
          float fft = tex2Dlod(_TextureFFT, float4(clamp(n, 0.0, 1.0), 0.0, 0, 0)).r;
          fft = log(fft);
          position -= v.normal * _GlobalFFT;
          /*position = rotateY(position, dist * 0.001 + fft * 0.1);*/
          /*position.x += sin(position.y);*/
          o.pos =  mul(UNITY_MATRIX_MVP, float4(position, 1.0));
          o.normal = float4(v.normal, 1.0);
          o.uv = TRANSFORM_TEX (v.texcoord, _MainTex);
          o.screenUV = ComputeScreenPos(o.pos);
          return o;
        }

        half4 frag (GS_INPUT i) : COLOR
        {
          float2 screenUV = i.screenUV.xy / i.screenUV.w;
          half4 color = tex2D(_MainTex, i.uv);
          /*i.normal = rotateY(i.normal, _Time * 100.0);
          i.normal = rotateX(i.normal, _Time * 100.0);*/
          color.rgb = i.normal * 0.5 + 0.5;
          return color;
        }
        ENDCG
      }
    }
    FallBack "Unlit/Transparent"
  }
