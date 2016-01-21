#pragma strict

var distortEffect : distortEffect;

function Update () {
		
	//if (Input.GetKeyDown ("d"))
	//	Application.LoadLevel(3);

	/*if (Input.GetKeyDown ("r")){
		//kaliedoscope.ResetKaliedoscope();
		//distortEffect.Realign();
	}*/
		
	if (Input.GetKeyDown (KeyCode.KeypadPlus)){
		distortEffect.deform += 0.02;
		//distortEffect.ResetKaliedoscope();
	}
		
	if (Input.GetKeyDown (KeyCode.KeypadMinus)){
		distortEffect.deform -= 0.02;
		//kaliedoscope.ResetKaliedoscope();
	}

}