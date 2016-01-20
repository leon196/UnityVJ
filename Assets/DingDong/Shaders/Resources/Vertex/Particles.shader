Shader "DingDong/Vertex/Particles" {
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
      Cull Off
      LOD 200

      CGPROGRAM
      #pragma vertex vert
      #pragma geometry geom
      #pragma fragment frag
      #include "UnityCG.cginc"
      #include "../Utils/Noise3D.cginc"
      #include "../Utils/Complex.cginc"
      #include "../Utils/Utils.cginc"

      struct GS_INPUT
      {
       float4 pos		: POSITION;
       float3 normal	: NORMAL;
       float2 uv	: TEXCOORD0;
       float4 screenUV : TEXCOORD1;
       float3 viewDir : TEXCOORD2;
      float value : TEXCOORD3;
     };

     struct FS_INPUT {
      float4 pos : SV_POSITION;
      half4 color : COLOR;
      float3 normal : NORMAL;
      float2 uv : TEXCOORD0;
      float4 screenUV : TEXCOORD1;
      float3 viewDir : TEXCOORD2;
      float value : TEXCOORD3;
    };

    sampler2D _MainTex;
    sampler2D _TextureFFT;
    float _GlobalFFT;
    float4 _MainTex_ST;
    fixed4 _Color;
    float _Size;
    float _Scale;
    float _Offset;
    float _ReaktorOutput;

    GS_INPUT vert (appdata_full v)
    {
      GS_INPUT o = (GS_INPUT)0;

      float4 vertex = v.vertex;

      // float t = _Time * 20.0;
      // float disp = dentDeScie(t + vertex.y * 4.0) * 0.05;//fmod(t + offset, 1.0);
      // float distRatio2 = smoothstep(0.5, 1.0, distRatio);
      // float dist = distRatio2 * 0.1;

      // vertex.xyz += v.normal * disp;

      o.pos =  vertex;//mul(_World2Object, v.vertex);
      o.normal = v.normal;
      o.uv = TRANSFORM_TEX (v.texcoord, _MainTex);
      o.screenUV = ComputeScreenPos(o.pos);
      return o;
    }

    [maxvertexcount(3)]
    void geom(triangle GS_INPUT tri[3], inout TriangleStream<FS_INPUT> triStream)
    {
      float3 a = tri[0].pos.xyz;//mul(_World2Object, tri[0].pos).xyz;
      float3 b = tri[1].pos.xyz;//mul(_World2Object, tri[1].pos).xyz;
      float3 c = tri[2].pos.xyz;//mul(_World2Object, tri[2].pos).xyz;
      float3 center = (a + b + c) / 3.0;

      float2 uvA = tri[0].uv;
      float2 uvB = tri[1].uv;
      float2 uvC = tri[2].uv;
      float2 uvCenter = (uvA + uvB + uvC) / 3.0;

      float3 triNormal = getNormal(a, b, c);

      float osc = sin(_Time * 100.0) * 0.5 + 0.5;
      // center += triNormal * osc * 0.05;

      float t = _Time * 20.0;
      float t2 = t * 10.0;
      float angle = center.y;
      // float angle = pow(length(center), 2.0) * 100.0 * _Slider + t;

      // float3 offset = float3(t, t * 3.0, 0);
      // float dist = noiseIQ((tri[0].normal + offset) * 2.0);
      // dist *= 0.05;

      float offset = a.y;//sin(a.x);//noiseIQ(triNormal * 100.0);

      float distRatio = dentDeScie(t + offset * 4.0) * 0.5;//fmod(t + offset, 1.0);
      float distRatio2 = smoothstep(0.5, 1.0, distRatio);
      float dist = distRatio2 * 0.1;
      // float dist = distRatio * 0.1;

      // Shrink
      a = lerp(a, center, distRatio);
      b = lerp(b, center, distRatio);
      c = lerp(c, center, distRatio);

      // Displace
      a += triNormal * dist;
      b += triNormal * dist;
      c += triNormal * dist;

      // Rotate
      a = rotateY(a, angle * distRatio2);
      b = rotateY(b, angle * distRatio2);
      c = rotateY(c, angle * distRatio2);

      triNormal = getNormal(a, b, c);

      FS_INPUT pIn = (FS_INPUT)0;
      pIn.pos = mul(UNITY_MATRIX_MVP, float4(a, 1.0));
      pIn.uv = tri[0].uv;
      pIn.normal = triNormal;
      pIn.color = half4(1.0,1.0,1.0,1.0);
      pIn.value = dist;
      triStream.Append(pIn);

      pIn.pos =  mul(UNITY_MATRIX_MVP, float4(b, 1.0));
      pIn.uv = tri[1].uv;
      pIn.normal = triNormal;
      pIn.color = half4(1.0,1.0,1.0,1.0);
      pIn.value = dist;
      triStream.Append(pIn);

      pIn.pos =  mul(UNITY_MATRIX_MVP, float4(c, 1.0));
      pIn.uv = tri[2].uv;
      pIn.normal = triNormal;
      pIn.color = half4(1.0,1.0,1.0,1.0);
      pIn.value = dist;
      triStream.Append(pIn);
    }

    half4 frag (FS_INPUT i) : COLOR
    {
      half4 color = _Color;
      color.rgb = rotateX(i.normal, i.value) * 0.5 + 0.5;
      // color.rgb = float3(1.0, 1.0, 1.0) * dot(i.normal, normalize(i.viewDir));
      color.a = 1.0;
      return color;
    }
    ENDCG
  }
}
FallBack "Unlit/Transparent"
}
