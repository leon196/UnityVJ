#pragma strict

var glitchyCam : glitchyCam;

function Update () {

	if (Input.GetKeyDown ("a"))
		Application.LoadLevel("circularize");
	if (Input.GetKeyDown ("b"))
		Application.LoadLevel("kaliedoscope_01");
	if (Input.GetKeyDown ("c"))
		Application.LoadLevel("PixelShift");
	if (Input.GetKeyDown ("d"))
		Application.LoadLevel("glitchycam");
		
	if (Input.GetKeyDown (KeyCode.KeypadPlus)){
		glitchyCam.intensity += 0.2;
		//distortEffect.ResetKaliedoscope();
	}
		
	if (Input.GetKeyDown (KeyCode.KeypadMinus)){
		glitchyCam.intensity -= 0.2;
		//kaliedoscope.ResetKaliedoscope();
	}

}