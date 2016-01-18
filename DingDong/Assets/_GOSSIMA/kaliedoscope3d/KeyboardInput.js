#pragma strict

var kaliedoscope : Kaliedoscope3D;

function Update () {


	if (Input.GetKeyDown ("a"))
		Application.LoadLevel("circularize");
	if (Input.GetKeyDown ("b"))
		Application.LoadLevel("kaliedoscope_01");
	if (Input.GetKeyDown ("c"))
		kaliedoscope.Realign();
	if (Input.GetKeyDown ("d"))
		Application.LoadLevel("glitchycam");
				
	if (Input.GetKeyDown (KeyCode.KeypadPlus)){
		kaliedoscope.kaliedoscopeBlades ++;
		kaliedoscope.ResetKaliedoscope();
	}
		
	if (Input.GetKeyDown (KeyCode.KeypadMinus)){
		if (kaliedoscope.kaliedoscopeBlades > 2){
			kaliedoscope.kaliedoscopeBlades --;
			kaliedoscope.ResetKaliedoscope();
		}
	}
		
	if (Input.GetKeyDown (KeyCode.Keypad1))
		kaliedoscope.complexity = 3;
	
	if (Input.GetKeyDown(KeyCode.Keypad2))
		kaliedoscope.complexity = 8;
		
	if (Input.GetKeyDown (KeyCode.Keypad3))
		kaliedoscope.complexity = 10;
		
	if (Input.GetKeyDown (KeyCode.Keypad4))
		kaliedoscope.complexity = 12;
		
	if (Input.GetKeyDown (KeyCode.Keypad5))
		kaliedoscope.complexity = 15;

}