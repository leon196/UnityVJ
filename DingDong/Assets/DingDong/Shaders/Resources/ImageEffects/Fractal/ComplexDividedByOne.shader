

Shader "Hidden/ComplexDividedByOne" {
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

      sampler2D _MainTex;
      float _GlobalFFT;
      float _GlobalFFTTotal;

      // Many Thanks to David Bau
      // http://davidbau.com/archives/2013/02/10/conformal_map_viewer.html

      float4 frag(v2f_img i) : COLOR
      {
        float2 uv = i.uv * 2.0 - 1.0;
        uv.x *= _ScreenParams.x / _ScreenParams.y;

        float angle = atan2(uv.y, uv.x) + _Time * 2.0;
        float dist = length(uv);
        uv = float2(cos(angle), sin(angle)) * dist;

        float fftAcceleration = (1.0 + _GlobalFFT);
        uv = complex_div(1.0, uv);

        float t = _Time * 10.0;

        uv.x = kaleido(uv.x, _GlobalFFTTotal * 0.1);
        uv.y = kaleido(uv.y, _GlobalFFTTotal * 0.1);

        float4 color = tex2D(_MainTex, uv);
        return color;
      }
      ENDCG
    }
  }
}
