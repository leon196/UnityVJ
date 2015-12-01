Shader "Basic/Wireframe"
{
  Properties
  {
    _Color ("Color", Color) = (1,1,1,1)
    _MainTex ("Texture (RGB)", 2D) = "white" {}
    _WireframeSize ("Wireframe Size", Float) = 0.05
  }
  SubShader
  {
    Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" }
    Pass
    {
      Blend SrcAlpha OneMinusSrcAlpha
      LOD 200
      Cull Off
      ZWrite Off

      CGPROGRAM
      #pragma vertex vert
      #pragma geometry geom
      #pragma fragment frag
      #include "UnityCG.cginc"

      struct GS_INPUT
      {
        float4 pos		: POSITION;
        float3 normal	: NORMAL;
        float2 uv	: TEXCOORD0;
        float4 screenUV : TEXCOORD1;
      };

      struct FS_INPUT
      {
        float4 pos : SV_POSITION;
        float2 uv : TEXCOORD0;
        float4 screenUV : TEXCOORD1;
        half4 color : COLOR;
        float3 normal : NORMAL;
      };

      sampler2D _MainTex;
      float4 _MainTex_ST;
      fixed4 _Color;
      float _WireframeSize;

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
        float4x4 vp = mul(UNITY_MATRIX_MVP, _World2Object);

        FS_INPUT pIn = (FS_INPUT)0;
        pIn.pos = mul(vp, tri[0].pos);
        pIn.uv = tri[0].uv;
        pIn.normal = tri[0].normal;
        pIn.color = half4(1.0,0.0,0.0,1.0);
        triStream.Append(pIn);

        pIn.pos =  mul(vp, tri[1].pos);
        pIn.uv = tri[1].uv;
        pIn.normal = tri[1].normal;
        pIn.color = half4(0.0,1.0,0.0,0.0);
        triStream.Append(pIn);

        pIn.pos =  mul(vp, tri[2].pos);
        pIn.uv = tri[2].uv;
        pIn.normal = tri[2].normal;
        pIn.color = half4(0.0,0.0,1.0,1.0);
        triStream.Append(pIn);
      }

      half4 frag (FS_INPUT i) : COLOR
      {
        float wireframeStep = 1.0 - smoothstep(0.0, _WireframeSize, i.color.r);
        wireframeStep += 1.0 - smoothstep(0.0, _WireframeSize, i.color.g);
        wireframeStep += 1.0 - smoothstep(0.0, _WireframeSize, i.color.b);
        wireframeStep = clamp(wireframeStep, 0.0, 1.0);

        half4 color = _Color * wireframeStep;
        color.a = wireframeStep;
        return color;
      }
      ENDCG
    }
  }
  FallBack "Unlit/Transparent"
}
