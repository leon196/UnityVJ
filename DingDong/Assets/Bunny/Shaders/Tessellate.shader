
//
//
// Thanks to RC-1290
// http://forum.unity3d.com/threads/dx11-tessellation-with-vertex-output-combination-not-working.173862/
//
//

Shader "Bunny/Tessellate" {
  Properties {
    _MainTex ("Base (RGB)", 2D) = "white" {}
      _Offset ("Offset", Float) = 10
      _Tess ("Tessellation", Float) = 2
    }
    SubShader {
      Tags { "RenderType"="Opaque" }
      Pass {

        CGPROGRAM
        #pragma vertex vert
        #pragma fragment frag
        #pragma hull tessBase
        #pragma domain basicDomain
        #pragma target 5.0
        #include "UnityCG.cginc"
        #define INTERNAL_DATA

        sampler2D _MainTex;
        sampler2D _TextureFFT;

        float4 _MainTex_ST;
        float _Offset;
        float _Tess;
        float _GlobalFFTTotal;
        float _GlobalFFT;

        struct v2f{
          float4 pos : SV_POSITION;
          float2 texcoord : TEXCOORD0;
          float3 normal : NORMAL;
          float3 color : COLOR;
        };

        #ifdef UNITY_CAN_COMPILE_TESSELLATION

        struct inputControlPoint{
          float4 position : WORLDPOS;
          float4 texcoord : TEXCOORD0;
          float4 tangent : TANGENT;
          float3 normal : NORMAL;
        };

        struct outputControlPoint{
          float3 position : BEZIERPOS;
        };

        struct outputPatchConstant{
          float edges[3]        : SV_TessFactor;
          float inside        : SV_InsideTessFactor;

          float3 vTangent[4]    : TANGENT;
          float2 vUV[4]         : TEXCOORD;
          float3 vTanUCorner[4] : TANUCORNER;
          float3 vTanVCorner[4] : TANVCORNER;
          float4 vCWts          : TANWEIGHTS;
        };


        outputPatchConstant patchConstantThing(InputPatch<inputControlPoint, 3> v){
          outputPatchConstant o;

          o.edges[0] = _Tess;
          o.edges[1] = _Tess;
          o.edges[2] = _Tess;
          o.inside = _Tess;

          return o;
        }

        // tessellation hull shader
        [domain("tri")]
        [partitioning("fractional_odd")]
        [outputtopology("triangle_cw")]
        [patchconstantfunc("patchConstantThing")]
        [outputcontrolpoints(3)]
        inputControlPoint tessBase (InputPatch<inputControlPoint,3> v, uint id : SV_OutputControlPointID) {
          return v[id];
        }

        #endif // UNITY_CAN_COMPILE_TESSELLATION

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

        v2f vert (appdata_tan v){
          v2f o;

          o.texcoord = v.texcoord;
          o.pos = v.vertex;
          o.normal = v.normal;

          return o;
        }

        v2f displace (appdata_tan v){
          v2f o;

          o.texcoord = TRANSFORM_TEX (v.texcoord, _MainTex);

          float3 position = v.vertex.xyz;
          float t = cos(_Time * 10.0) * 0.5 + 0.5;
          float tt = _Time * 10.0;
          float radius = 5.0;
          float3 target = float3(cos(tt) * radius, 0.0, sin(tt) * radius);
          float dist = 1.0 / log(length(position));
          /*float fft = tex2Dlod(_TextureFFT, float4(clamp(sin(length(position) * 4.0) * 0.5 + 0.5, 0.0, 1.0), 0.0, 0, 0)).r;*/
          /*float x = sin(length(v.vertex.xz)) * 0.5 + 0.5;*/
          float x = 1.0 - abs(fmod(length(v.vertex.xyz) + tt, 1.0) * 2.0 - 1.0);
          float fft = tex2Dlod(_TextureFFT, float4(x, 0, 0, 0)).r;
          /*fft = log(fft);*/
          /*float3 direction = normalize(v.normal) * fft;*/
          float3 direction = normalize(position) * 0.5 * fft;
          /*direction.x = 0.0;*/
          position += direction;

          o.pos = mul(UNITY_MATRIX_MVP, float4(position, 1.0));
          o.normal = v.normal;
          float4 color = float4(1.0, 1.0, 1.0, 1.0);
          color.rgb *= fft;
          o.color = color;

          return o;
        }

        #ifdef UNITY_CAN_COMPILE_TESSELLATION

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

        // tessellation domain shader
        [domain("tri")]
        v2f basicDomain (outputPatchConstant tessFactors, const OutputPatch<inputControlPoint,3> vi, float3 bary : SV_DomainLocation) {
          appdata_tan v;
          v.vertex = vi[0].position*bary.x + vi[1].position*bary.y + vi[2].position*bary.z;
          v.tangent = vi[0].tangent*bary.x + vi[1].tangent*bary.y + vi[2].tangent*bary.z;
          v.normal = vi[0].normal*bary.x + vi[1].normal*bary.y + vi[2].normal*bary.z;
          v.texcoord = vi[0].texcoord*bary.x + vi[1].texcoord*bary.y + vi[2].texcoord*bary.z;
          v2f o = displace( v);
          o.normal = getTriangleNormal(vi[0].position.xyz, vi[1].position.xyz, vi[2].position.xyz);
          //                v2f o = vert_surf (v);
          return o;
        }

        #endif // UNITY_CAN_COMPILE_TESSELLATION


        float4 frag(in v2f IN):COLOR
        {
          float4 color = float4(0.0, 0.0, 0.0, 1.0);
          float t = _Time * 20.0;
          color.rgb = IN.normal * 0.5 + 0.5;
          /*color.rgb *= dot(normalize(float3(-1.0, 1.0, 0.0)), IN.normal) * 0.5 + 0.5;*/
          color.rgb *= lerp(1.0, 1.5, IN.color.r);
          return color;
        }

        ENDCG
      }
    }
  }
