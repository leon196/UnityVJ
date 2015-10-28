Shader "Warband/Tornado" {
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
        #include "UnityCG.cginc"

        struct GS_INPUT
        {
          float4 pos		: POSITION;
          float3 normal	: NORMAL;
          float2 uv	: TEXCOORD0;
          float4 screenUV : TEXCOORD1;
          float4 color : COLOR;
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
        float _GlobalFFT;
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

        // hash based 3d value noise
        // function taken from https://www.shadertoy.com/view/XslGRr
        // Created by inigo quilez - iq/2013
        // License Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License.

        // ported from GLSL to HLSL
        float hash( float n )
        {
          return frac(sin(n)*43758.5453);
        }

        float noise( float3 x )
        {
          // The noise function returns a value in the range -1.0f -> 1.0f
          float3 p = floor(x);
          float3 f = frac(x);
          f       = f*f*(3.0-2.0*f);
          float n = p.x + p.y*57.0 + 113.0*p.z;
          return lerp(lerp(lerp( hash(n+0.0), hash(n+1.0),f.x),
          lerp( hash(n+57.0), hash(n+58.0),f.x),f.y),
          lerp(lerp( hash(n+113.0), hash(n+114.0),f.x),
          lerp( hash(n+170.0), hash(n+171.0),f.x),f.y),f.z);
        }

        float g (float x)
        {
          return 0.01 / log(fmod(abs(x),2.0));
        }

        float g2 (float x)
        {
          return log(abs(x)) + 2.0;
        }

        GS_INPUT vert (appdata_full v)
        {
          GS_INPUT o = (GS_INPUT)0;
          float3 position = mul(_Object2World, v.vertex).xyz;
          float t = cos(_Time * 10.0) * 0.5 + 0.5;
          float tt = _Time * 10.0;
          float radius = 5.0;
          float3 target = float3(cos(tt) * radius, 0.0, sin(tt) * radius);
          /*float dist = 1.0 / g2(length(position));//log(length(position));*/
          /*float fft = tex2Dlod(_TextureFFT, float4(clamp(sin(length(position) * 0.1) * 0.5 + 0.5, 0.0, 1.0), 0.0, 0, 0)).r;*/

          /*fft = log(fft);*/
          /*position.y += _GlobalFFT * 0.5;*/
          /*float x = 1.0 - abs(fmod(length(v.vertex.xyz), 1.0) * 2.0 - 1.0);*/
          float x = ((v.normal.x + v.normal.y + v.normal.z) / 3.0) * 0.5 + 0.5;
          float fft = tex2Dlod(_TextureFFT, float4(x, 0, 0, 0)).r;
          /*float dist = 10.0 / (log(length(position) * 1.0) + log(fft) * 0.5);*/
          /*position += normalize(position) * (fft * 100.0);*/
          /*position = rotateX(position, tt * 2.0);*/
          /*position = rotateY(position, fft);*/
          float3 pp = normalize(position) * (fft * 8.0 + 2.0);
          position = position + rotateY(pp, length(position) + tt * 10.0);
          /*position = rotateX(position, sin(_GlobalFFT * 0.01));// + _GlobalFFTTotal * 0.001);*/
          /*position = rotateY(position, dist + tt);// + _GlobalFFTTotal * 0.001);*/
          /*position = rotateY(position, sin(dist + _GlobalFFT * 0.01));*/
          /*v.vertex.xyz = rotateX(v.vertex.xyz, angle);*/
          /*position.x += sin(position.y);*/
          o.pos =  mul(UNITY_MATRIX_MVP, float4(position, 1.0));
          o.normal = v.normal;
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
