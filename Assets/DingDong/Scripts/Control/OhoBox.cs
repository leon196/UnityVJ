using UnityEngine;
using System.Collections;

public class OhoBox : MonoBehaviour
{
	Arduino arduino;
	Zapping zapping;
	SwitchCamera switchCamera;

	void Start ()
	{
		arduino = new Arduino();
		zapping = GetComponent<Zapping>();
		switchCamera = GetComponent<SwitchCamera>();
	}

	void Update ()
	{
		if (arduino.isEnabled) {
			arduino.Update();
			Shader.SetGlobalFloat("_OhoSlider1", arduino.Slider(1));
			Shader.SetGlobalFloat("_OhoSlider2", arduino.Slider(2));
			Shader.SetGlobalFloat("_OhoSlider3", arduino.Slider(3));
			Shader.SetGlobalFloat("_OhoSpiner1", arduino.Spiner(1));
			Shader.SetGlobalFloat("_OhoSpiner2", arduino.Spiner(2));
			Shader.SetGlobalFloat("_OhoSpiner3", arduino.Spiner(3));

			if (zapping && arduino.ButtonPressed(1)) {
				zapping.Zap();
			}
			if (switchCamera && arduino.ButtonPressed(3)) {
				switchCamera.Switch();
			}
		}
	}
}
