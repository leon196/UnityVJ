Shader "Unlit/WireframeDisplace" {
    Properties {
    _Color ("Main Color", Color) = (1,1,1,1)
      _MainTex ("Texture", 2D) = "white" {}
      _Amount ("Extrusion Amount", Range(-100,100)) = 0.5
      _t ("xdfg", Range(-10,10)) = 0.5
      _EdgeLength ("Edge length", Range(2,50)) = 15
    }
    SubShader {
      Tags { "RenderType" = "Opaque" }
      Cull off
      CGPROGRAM
       #pragma surface surf BlinnPhong addshadow fullforwardshadows vertex:vert tessellate:tessEdge nolightmap
	    #pragma target 5.0
	    #include "Tessellation.cginc"
      struct Input {
          float2 uv_MainTex;
      };
      
      
      struct appdata {
            float4 vertex : POSITION;
            float4 texcoord : TEXCOORD0;
            float3 normal : NORMAL;
        };
      
      sampler2D _MainTex;
      sampler2D _WebcamTexture;
      float _Amount;
      float _t;
       fixed4 _Color;
      
      float _EdgeLength;

            float4 tessEdge (appdata v0, appdata v1, appdata v2)
            {
                return UnityEdgeLengthBasedTess (v0.vertex, v1.vertex, v2.vertex, _EdgeLength);
            }
      
      void vert (inout appdata v) {
      
      //1-abs(x*2-01)
      float4 uv = float4((v.texcoord.xy),0,0);
      //uv.x = 1-abs(uv.x*2-01);
      //uv.y = 1-abs(uv.y*2-01);
      
      	 float4 tex = tex2Dlod (_WebcamTexture, uv);
      	 float plouf = lerp(tex.x,1.0-tex.x,0.5+0.5*_t);
          v.vertex.xyz += v.normal * _Amount * (plouf-0.2)  ;
          //v.texcoord.xy
      }
      
      void surf (Input IN, inout SurfaceOutput o) {
      	
      	float2 uv =	IN.uv_MainTex ;
      	//uv.x = 1-abs(uv.x*2-01);
      //uv.y = 1-abs(uv.y*2-01);
      
         // o.Albedo = tex2D (_MainTex, uv).rgb * _Color;
          o.Emission = tex2D (_WebcamTexture, uv).rgb ;
         // o.Emission = pow ((1 - tex2D (_MainTex, uv).rgb),10) * _Color *3;
      }
      ENDCG
    } 
    Fallback "Diffuse"
  }