#pragma strict

var kaliedoscope : Kaliedoscope3D;

function Update () {

	if (Input.GetKeyDown ("a"))
		kaliedoscope.Realign();
	if (Input.GetKeyDown ("b"))
		Application.LoadLevel("kaliedoscope_01");
	if (Input.GetKeyDown ("c"))
		Application.LoadLevel("PixelShift");
	if (Input.GetKeyDown ("d"))
		Application.LoadLevel("glitchycam");

	/*if (Input.GetKeyDown ("r")){
		//kaliedoscope.ResetKaliedoscope();
		kaliedoscope.Realign();
	}*/
		
	if (Input.GetKeyDown (KeyCode.KeypadPlus)){
		kaliedoscope.complexity ++;
		kaliedoscope.ResetKaliedoscope();
	}
		
	if (Input.GetKeyDown (KeyCode.KeypadMinus)){
		kaliedoscope.complexity --;
		kaliedoscope.ResetKaliedoscope();
	}
		
}