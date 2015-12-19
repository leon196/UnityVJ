Shader "Hidden/GlitchScanline" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
	}
	SubShader {
		Pass {
			CGPROGRAM
			#pragma vertex vert_img
			#pragma fragment frag
			#pragma target 3.0

			#include "UnityCG.cginc"
			#include "../../Utils/Utils.cginc"
			#include "../../Utils/Complex.cginc"
			#include "../../Utils/ClassicNoise2D.cginc"

			sampler2D _MainTex;
			sampler2D _BufferTexture;
			float _ReaktorOutput;

			half4 frag (v2f_img i) : COLOR
			{
				float2 uv = i.uv;

				float2 center = float2(0.5, 0.5);
				float2 r1res = pow(2.0, 10.0);
				float2 r2res = pow(2.0, 7.0);
				float2 r3res = pow(2.0, 4.0);
				float t = _Time * 0.1;
				float tt = _Time;
				float scale = _ReaktorOutput * 200.0 + 100.0;
        float random1 = (cnoise(pixelize(uv + float2(0, t), r1res).yy * scale) - center) * 2.0;
        float random2 = (cnoise(pixelize(uv - float2(0, t), r2res).yy * scale) - center) * 2.0;

        float4 tex = tex2D(_MainTex, uv);

        float2 scanlineGlitch =  float2(random2 * random1, 0) * 0.02 * _ReaktorOutput;
        float2 offsetRed = float2(0.01, 0.005) * _ReaktorOutput * 2.0;
        float2 offsetGreen = float2(0, 0) * _ReaktorOutput * 2.0;
        float2 offsetBlue = float2(-0.01, 0.005) * _ReaktorOutput * 2.0;

        float luminance = tex.r * .2126 + tex.g * .7152 + tex.b * .0722;

        // uv += (float2(0.5, 0.5)) * luminance;

        uv += scanlineGlitch;

        float textureRed = tex2D(_MainTex, uv + offsetRed).r;
        float textureGreen = tex2D(_MainTex, uv + offsetGreen).g;
        float textureBlue = tex2D(_MainTex, uv + offsetBlue).b;
        float textureAlpha = tex2D(_MainTex, uv).a;

        float4 color = float4(textureRed, textureGreen, textureBlue, textureAlpha);

				return color;
			}
			ENDCG
		}
	}
	FallBack "Unlit/Transparent"
}
