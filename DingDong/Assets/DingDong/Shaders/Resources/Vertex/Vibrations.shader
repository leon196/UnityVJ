Shader "DingDong/Vertex/Vibrations" {
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
        #include "../Utils/Utils.cginc"

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
        float _ReaktorOutput;

        GS_INPUT vert (appdata_full v)
        {
          GS_INPUT o = (GS_INPUT)0;
          float3 position = v.vertex.xyz;
          float3 localPosition = mul(_World2Object, v.vertex).xyz;

          float dist = length(position);
          dist = sin(dist * 10.0);

          position += v.normal * _ReaktorOutput * 0.1 * dist;
          // position = normalize(position) * dist * _ReaktorOutput;

          o.pos =  mul(UNITY_MATRIX_MVP, float4(position, 1.0));
          o.normal = float4(v.normal, 1.0);
          o.uv = TRANSFORM_TEX (v.texcoord, _MainTex);
          o.screenUV = ComputeScreenPos(o.pos);
          return o;
        }

        half4 frag (GS_INPUT i) : COLOR
        {
          fixed3 color = i.normal * 0.5 + 0.5;
          return fixed4(color, 1.0);
        }
        ENDCG
      }
    }
    FallBack "Unlit/Transparent"
  }
