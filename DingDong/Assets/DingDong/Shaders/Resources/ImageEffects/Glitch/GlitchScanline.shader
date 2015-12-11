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

        float random1 = (noiseIQ(pixelize(uv + float2(0, _Time * 0.0001), pow(2.0, 10.0)).yy) - 0.5) * 2.0;
        float random2 = (noiseIQ(pixelize(uv - float2(0, _Time * 0.0001), pow(2.0, 7.0)).yy) - 0.5) * 2.0;
        float random3 = noiseIQ(pixelize(float2(0, _Time), pow(2.0, 4.0)).yy);

        /*float timing = (cos(_Time * 0.001) * 0.5 + 0.5);
        float timingGlitch = step(random3, timing);*/

        float4 texture = tex2D (_MainTex, uv);

        float2 scanlineGlitch =  float2(random2 * random1 * uOffsetGlitch, 0) * uSliderGlitch;
        float2 offsetRed = float2(0.01, 0.005) * uSliderRGB;
        float2 offsetGreen = float2(0, 0) * uSliderRGB;
        float2 offsetBlue = float2(-0.01, 0.005) * uSliderRGB;

        float luminance = texture.r * .2126 + texture.g * .7152 + texture.b * .0722;

        uv += (float2(0.5, 0.5)) * luminance;

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
