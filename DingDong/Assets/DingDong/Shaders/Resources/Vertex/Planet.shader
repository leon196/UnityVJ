Shader "DingDong/Vertex/Planet" {
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
        sampler2D _VideoTexture;
        float4 _MainTex_ST;
        fixed4 _Color;
        float _Size;
        float _GlobalFFT;
        float _GlobalFFTTotal;

        float2 getTextureCoordinates (float2 uv)
        {
        	uv *= 6.0;
        	uv.x = kaleido(uv.x, 0);
        	uv.y = kaleido(uv.y, 0);
        	return uv;
        }

        GS_INPUT vert (appdata_full v)
        {
          GS_INPUT o = (GS_INPUT)0;
          float3 position = v.vertex.xyz;//mul(_Object2World, v.vertex).xyz;

          float lum = Luminance(tex2Dlod(_VideoTexture, float4(getTextureCoordinates(v.texcoord.xy), 0, 0)));

          position += normalize(position) * lum;

          o.pos =  mul(UNITY_MATRIX_MVP, float4(position, 1.0));
          o.normal = float4(v.normal, 1.0);
          o.uv = TRANSFORM_TEX (v.texcoord, _MainTex);
          o.screenUV = ComputeScreenPos(o.pos);
          return o;
        }

        half4 frag (GS_INPUT i) : COLOR
        {
        	float2 uv = i.uv;

        	uv *= 6.0;

        	uv.x = kaleido(uv.x, 0);
        	uv.y = kaleido(uv.y, 0);

          half4 color = tex2D(_VideoTexture, uv);
          return color;
        }
        ENDCG
      }
    }
    FallBack "Unlit/Transparent"
  }
