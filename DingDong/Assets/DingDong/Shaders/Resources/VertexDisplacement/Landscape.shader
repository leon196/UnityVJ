Shader "DingDong/Vertex/Landscape" {
  Properties {
    _Color ("Color", Color) = (1,1,1,1)
    _MainTex ("Texture (RGB)", 2D) = "white" {}
  }
  SubShader {
    Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" }
    Pass {
	Blend SrcAlpha OneMinusSrcAlpha
	LOD 200
	Cull Off

	CGPROGRAM
	#pragma vertex vert
	#pragma geometry geom
	#pragma fragment frag
	#include "UnityCG.cginc"
	#include "../Utils/Noise3D.cginc"
	#include "../Utils/Utils.cginc"

	struct GS_INPUT
	{
		float4 pos		: POSITION;
		float3 normal	: NORMAL;
		float2 uv	: TEXCOORD0;
		float4 screenUV : TEXCOORD1;
		float3 viewDir : TEXCOORD2;
		half4 color : COLOR;
		float height : TEXCOORD3;
		float3 wire : TEXCOORD4;
	};

	struct FS_INPUT {
      float4 pos : SV_POSITION;
      float2 uv : TEXCOORD0;
      float4 screenUV : TEXCOORD1;
      half4 color : COLOR;
      float3 normal : NORMAL;
      float3 viewDir : TEXCOORD2;
      float height : TEXCOORD3;
      float3 wire : TEXCOORD4;
    };

    sampler2D _MainTex;
    sampler2D _FFTMemory;
    float4 _MainTex_ST;
    fixed4 _Color;
    float _GlobalFFT;

    GS_INPUT vert (appdata_full v)
    {
      GS_INPUT o = (GS_INPUT)0;
      o.uv = TRANSFORM_TEX (v.texcoord, _MainTex);
      float2 uv = o.uv;
      float height = tex2Dlod(_FFTMemory, float4(uv, 0.0, 0.0)).r;
      v.vertex.xyz -= v.normal * height * 0.25 * uv.y - v.normal * _GlobalFFT  * uv.y;
      o.pos =  mul(_Object2World, v.vertex);
      o.normal = v.normal;
      o.height = height;
      o.color = v.color;
      o.screenUV = ComputeScreenPos(o.pos);
      return o;
    }

    [maxvertexcount(3)]
    void geom(triangle GS_INPUT tri[3], inout TriangleStream<FS_INPUT> triStream)
    {
      float3 a = mul(_World2Object, tri[0].pos).xyz;
      float3 b = mul(_World2Object, tri[1].pos).xyz;
      float3 c = mul(_World2Object, tri[2].pos).xyz;

      float3 triNormal = getNormal(a, b, c);

      FS_INPUT pIn = (FS_INPUT)0;
      pIn.pos = mul(UNITY_MATRIX_MVP, float4(a, 1.0));
      pIn.uv = tri[0].uv;
      pIn.normal = tri[0].normal;
      pIn.color = tri[0].color;
      pIn.height = tri[0].height;
      pIn.wire = float3(1.0, 0.0, 0.0);
      triStream.Append(pIn);

      pIn.pos =  mul(UNITY_MATRIX_MVP, float4(b, 1.0));
      pIn.uv = tri[1].uv;
      pIn.normal = tri[1].normal;
      pIn.color = tri[1].color;
      pIn.height = tri[1].height;
      pIn.wire = float3(0.0, 1.0, 0.0);
      triStream.Append(pIn);

      pIn.pos =  mul(UNITY_MATRIX_MVP, float4(c, 1.0));
      pIn.uv = tri[2].uv;
      pIn.normal = tri[2].normal;
      pIn.color = tri[2].color;
      pIn.height = tri[2].height;
      pIn.wire = float3(0.0, 0.0, 1.0);
      triStream.Append(pIn);
    }

    half4 frag (FS_INPUT i) : COLOR
    {
		half4 color = _Color;
		color.rgb = i.normal * 0.5 + 0.5;
		color.rgb *= i.height;// * 0.75 + 0.25;


		// float wireframeSize = 0.05;
		// float wireframeStep = 1.0 - smoothstep(0.0, wireframeSize, i.wire.r);
		// wireframeStep += 1.0 - smoothstep(0.0, wireframeSize, i.wire.g);
		// wireframeStep += 1.0 - smoothstep(0.0, wireframeSize, i.wire.b);
		// wireframeStep = clamp(wireframeStep, 0.0, 1.0);
		// color.a = wireframeStep;

		// color.a = lerp(step(fmod(i.uv.y, 0.01), 0.001), 1.0, i.height);
		return color;
    }
    ENDCG
  }
}
FallBack "Unlit/Transparent"
}
