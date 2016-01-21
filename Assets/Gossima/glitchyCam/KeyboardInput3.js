#pragma strict

var glitchyCam : glitchyCam;

function Update () {
		
	if (Input.GetKeyDown (KeyCode.KeypadPlus)){
		glitchyCam.intensity += 0.2;
		//distortEffect.ResetKaliedoscope();
	}
		
	if (Input.GetKeyDown (KeyCode.KeypadMinus)){
		glitchyCam.intensity -= 0.2;
		//kaliedoscope.ResetKaliedoscope();
	}

}