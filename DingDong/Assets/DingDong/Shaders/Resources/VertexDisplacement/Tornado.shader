Shader "DingDong/Vertex/Tornado" {
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
      #include "../Utils/Noise3D.cginc"
      #include "../Utils/Utils.cginc"

      struct GS_INPUT
      {
       float4 pos		: POSITION;
       float3 normal	: NORMAL;
       float2 uv	: TEXCOORD0;
       float4 screenUV : TEXCOORD1;
       float3 viewDir : TEXCOORD2;
     };

     struct FS_INPUT {
      float4 pos : SV_POSITION;
      float2 uv : TEXCOORD0;
      float4 screenUV : TEXCOORD1;
      half4 color : COLOR;
      float3 normal : NORMAL;
      float3 viewDir : TEXCOORD2;
    };

    sampler2D _MainTex;
    sampler2D _TextureFFT;
    float _GlobalFFT;
    float4 _MainTex_ST;
    fixed4 _Color;
    float _Size;
    float _Scale;
    float _Offset;

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
      float3 a = mul(_World2Object, tri[0].pos).xyz;
      float3 b = mul(_World2Object, tri[1].pos).xyz;
      float3 c = mul(_World2Object, tri[2].pos).xyz;
      float3 center = (a + b + c) / 3.0;
      // float3 viewDir = normalize(WorldSpaceViewDir(float4(g, 1.0)));

      float2 uvA = tri[0].uv;
      float2 uvB = tri[1].uv;
      float2 uvC = tri[2].uv;
      float2 uvCenter = (uvA + uvB + uvC) / 3.0;

      float x = (uvCenter.x * 16.0 + uvCenter.y * 16.0) / 32.0;
      float fft = tex2Dlod(_TextureFFT, float4(x, 0, 0, 0)).r;

      float dist = snoise(center * 10.0) * 0.5 + 0.5;
      a = normalize(a) * dist * (0.1 + fft);
      // b = normalize(b) * dist * (0.1 + fft);
      // c = normalize(c) * dist * (0.1 + fft);
      b = normalize(b) * dist * 0.1;
      c = normalize(c) * dist * 0.1;

      float angle = pow(dist, 2.0);
      // float x = dentDeScie(angle);
      // float x = vectorToNumber1(triNormal);
      // float x = vectorToNumber2(triNormal);
      // float x = vectorToNumber3(triNormal, viewDir);
      // float fft = _GlobalFFT;

      // Scale
      // center = (a + b + c) / 3.0;
      // a += normalize(a - center) * fft * 0.1;
      // b += normalize(b - center) * fft * 0.1;
      // c += normalize(c - center) * fft * 0.1;

      // a = rotateY(a, angle * fft);
      // b = rotateY(b, angle * fft);
      // c = rotateY(c, angle * fft);


      float3 triNormal = getNormal(a, b, c);

      FS_INPUT pIn = (FS_INPUT)0;
      pIn.pos = mul(UNITY_MATRIX_MVP, float4(a, 1.0));
      pIn.uv = tri[0].uv;
      pIn.normal = triNormal;
      pIn.color = half4(1.0,1.0,1.0,1.0);
      pIn.color.rgb *= fft;
      triStream.Append(pIn);

      pIn.pos =  mul(UNITY_MATRIX_MVP, float4(b, 1.0));
      pIn.uv = tri[1].uv;
      pIn.normal = triNormal;
      pIn.color = half4(1.0,1.0,1.0,1.0);
      pIn.color.rgb *= fft;
      triStream.Append(pIn);

      pIn.pos =  mul(UNITY_MATRIX_MVP, float4(c, 1.0));
      pIn.uv = tri[2].uv;
      pIn.normal = triNormal;
      pIn.color = half4(1.0,1.0,1.0,1.0);
      pIn.color.rgb *= fft;
      triStream.Append(pIn);
    }

    half4 frag (FS_INPUT i) : COLOR
    {
      half4 color = _Color;
      // color.rgb = i.normal * 0.5 + 0.5;
      // color.rgb = float3(1.0, 1.0, 1.0) * dot(i.normal, normalize(i.viewDir));
      color.rgb = i.color.rgb;
      color.a = 1.0;
      return color;
    }
    ENDCG
  }
}
FallBack "Unlit/Transparent"
}
