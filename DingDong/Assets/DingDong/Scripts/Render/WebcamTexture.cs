using UnityEngine;
using System.Collections;

public class WebcamTexture : MonoBehaviour {

	public Material materialWebcam;
	public Material materialDifference;
	public float differenceTreshold = 0.3f;
	public float differenceRefreshTreshold = 0.5f;
	public float differenceFadeOutRatio = 0.95f;
	WebCamTexture textureWebcam;
	Texture2D textureDiff;
	Color[] colorArray;
	Color[] colorBufferArray;

	void Start () {

		if (WebCamTexture.devices.Length > 0) {

			// Setup webcam texture
			textureWebcam = new WebCamTexture();
			textureWebcam.Play();
			Shader.SetGlobalTexture("_WebcamTexture", textureWebcam);
			if (materialWebcam != null) {
				materialWebcam.mainTexture = textureWebcam;
			}

			// Setup color array
			colorArray = new Color[textureWebcam.width * textureWebcam.height];
			colorBufferArray = new Color[textureWebcam.width * textureWebcam.height];
			for (int i = 0; i < colorArray.Length; ++i) {
				colorArray[i] = Color.black;
				colorBufferArray[i] = Color.black;
			}

			// Setup procedural texture
			textureDiff = new Texture2D(textureWebcam.width, textureWebcam.height, TextureFormat.ARGB32, false);
			textureDiff.SetPixels(colorArray);
			textureDiff.Apply(false);
			Shader.SetGlobalTexture("_DifferenceTexture", textureDiff);
		}
	}
	
	void Update () {
		int diffCount = 0;
		if (textureWebcam) {
			Color[] colorPixelArray = textureWebcam.GetPixels();
			for (int i = 0; i < colorArray.Length; ++i) {
				Color currentColor = colorArray[i];
				Color newColor = colorPixelArray[i];
				Color bufferColor = colorBufferArray[i];
				float lumCurrent = (currentColor.r + currentColor.g + currentColor.b) / 3.0f;
				float lumNew = (newColor.r + newColor.g + newColor.b) / 3.0f;
				float lumBuffer = (bufferColor.r + bufferColor.g + bufferColor.b) / 3.0f;
				float lum = Mathf.Abs(lumNew - lumBuffer);

				if (lum < differenceTreshold) {
					lum = 0f;//lumCurrent * differenceFadeOutRatio;
				} else {
					lum = 1f;
					++diffCount;
				}

				colorArray[i] = new Color(lum, lum, lum, 1f);
				colorBufferArray[i] = newColor;
			}
			if (diffCount > differenceRefreshTreshold * colorArray.Length) {
				textureDiff.SetPixels(colorArray);
				textureDiff.Apply(false);
			}
		}
	}
}
