using UnityEngine;
using System.Collections;

public class FFTMemory : MonoBehaviour
{
	Texture2D memoryTexture;
	Color[] colorArray;
	const int memoryLength = 128;

	void Start ()
	{
		memoryTexture = new Texture2D(OSCReceiverC.OSCcount, memoryLength);
	    colorArray = new Color[OSCReceiverC.OSCcount * memoryLength];
	    for (int i = 0; i < OSCReceiverC.OSCcount * memoryLength; i++) {
	      colorArray[i] = new Color(1f, 1f, 1f, 1f);
	    }
	    memoryTexture.SetPixels(colorArray);
	    memoryTexture.Apply();
	    Shader.SetGlobalTexture("_FFTMemory", memoryTexture);
	}

	void Update ()
	{
		float fft;
		Color color;
		for (int i = OSCReceiverC.OSCcount * memoryLength - 1; i >= OSCReceiverC.OSCcount; --i) {
			color = colorArray[i - OSCReceiverC.OSCcount];
			colorArray[i] = color;
		}
		for (int i = 0; i < OSCReceiverC.OSCcount; ++i) {
			fft = OSCReceiverC.OSCvalues[i];
			colorArray[i] = new Color(fft, fft, fft, 1f);
		}
	    memoryTexture.SetPixels(colorArray);
	    memoryTexture.Apply();
	}
}