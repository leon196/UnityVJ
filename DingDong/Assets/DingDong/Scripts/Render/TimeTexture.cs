using UnityEngine;
using System.Collections;

public class TimeTexture : MonoBehaviour
{
	WebCamTexture textureWebcam;
	Texture2D texture;
	Color[][] colorList;
	int width;
	int height;
	int segments = 10;
	float timeLast = 0f;
	float timeDelay = 0.000f;

	void Start ()
	{
		if (WebCamTexture.devices.Length > 0) {
			textureWebcam = new WebCamTexture();
			textureWebcam.Play();
			width = textureWebcam.width;
			height = textureWebcam.height;
			texture = new Texture2D(width, height);
			segments = (int)Screen.height;
			colorList = new Color[segments][];
			for (int i = 0; i < segments; ++i) {
				Color[] color = new Color[width * height];
				for (int c = 0; c < width * height; ++c) {
					color[c] = Color.black;
				}
				colorList[i] = color;
			}
			texture.SetPixels(colorList[0]);
			texture.Apply(false);
			Shader.SetGlobalTexture("_TimeTexture", texture);
		}
	}

	void Update ()
	{
		if (textureWebcam && timeLast + timeDelay < Time.time) {
			timeLast = Time.time;
			Color[] webcamColors = textureWebcam.GetPixels();
			Color[] newColors = new Color[webcamColors.Length];
			for (int i = segments - 1; i > 0; --i) {
				colorList[i] = colorList[i - 1];
			}
			colorList[0] = webcamColors;
			for (int c = 0; c < webcamColors.Length; ++c) {
				int i = (int)Mathf.Floor((c / (float)webcamColors.Length) * segments);
				newColors[c] = colorList[i][c];
			}

			texture.SetPixels(newColors);
			texture.Apply(false);
		}
	}
}