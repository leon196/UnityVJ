using UnityEngine;
using System.Collections;

public class WebcamManager : MonoBehaviour {

	public Material materialWebcam;
	public Material materialDifference;
	public float differenceTreshold = 0.3f;
	public float differenceRefreshTreshold = 0.03f;
	public float differenceFadeOutRatio = 0.95f;
	public WebCamTexture texture;
	Texture2D textureDiff;
	Color[] colorArray;
	Color[] colorBufferArray;

	// public Vector2 focusPoint = Vector2.zero;
	// public Vector2 focusPointTarget = Vector2.zero;
	public bool pixelTouchedTarget = false;
	public float targetRadius = 0.1f;
	public Vector2 targetPoint = Vector2.zero;
	Vector2 p = Vector2.zero;
	// Vector2 point = Vector2.zero;

	void Awake () {
			
		Shader.SetGlobalFloat("_FadeOutRatio", differenceFadeOutRatio);

		if (WebCamTexture.devices.Length > 0) {

			// Setup webcam texture
			texture = new WebCamTexture();
			texture.Play();
			texture.filterMode = FilterMode.Point;
			Shader.SetGlobalTexture("_WebcamTexture", texture);
			if (materialWebcam != null) {
				materialWebcam.mainTexture = texture;
			}

			// Setup color array
			colorArray = new Color[texture.width * texture.height];
			colorBufferArray = new Color[texture.width * texture.height];
			for (int i = 0; i < colorArray.Length; ++i) {
				colorArray[i] = Color.black;
				colorBufferArray[i] = Color.black;
			}

			// Setup procedural texture
			textureDiff = new Texture2D(texture.width, texture.height, TextureFormat.ARGB32, false);
			textureDiff.filterMode = FilterMode.Point;
			textureDiff.SetPixels(colorArray);
			textureDiff.Apply(false);
			Shader.SetGlobalTexture("_DifferenceTexture", textureDiff);
		}
	}
	
	void FixedUpdate () {
		int diffCount = 0;
		pixelTouchedTarget = false;
		p = Vector2.zero;
		// point = Vector2.zero;
		if (texture) {
			Color[] colorPixelArray = texture.GetPixels();
			for (int i = 0; i < colorArray.Length; ++i) {

				//Color currentColor = colorArray[i];
				Color newColor = colorPixelArray[i];
				Color bufferColor = colorBufferArray[i];
				//float lumCurrent = (currentColor.r + currentColor.g + currentColor.b) / 3.0f;
				// float lumNew = (newColor.r + newColor.g + newColor.b) / 3.0f;
				// float lumBuffer = (bufferColor.r + bufferColor.g + bufferColor.b) / 3.0f;
				float lum;// = Mathf.Abs(lumNew - lumBuffer);

				if (Mathf.Abs(newColor.r - bufferColor.r) < differenceTreshold
					|| Mathf.Abs(newColor.g - bufferColor.g) < differenceTreshold
					|| Mathf.Abs(newColor.b - bufferColor.b) < differenceTreshold) {
				// if (lum < differenceTreshold) {
					lum = 0f;//lumCurrent * differenceFadeOutRatio;
				} else {
					lum = 1f;
					++diffCount;

					p.x = (i % texture.width) / (float)texture.width;
					p.y = Mathf.Floor(i / texture.width) / (float)texture.height;

					// point += p;

					if (Vector2.Distance(p, targetPoint) < targetRadius) {
						pixelTouchedTarget = true;
					}
				}

				colorArray[i] = new Color(lum, lum, lum, 1f);
				colorBufferArray[i] = newColor;
			}

			// if (diffCount > 0) {
			// 	point /= diffCount;
			// 	focusPointTarget = point;
			// }

			// focusPoint = Vector2.Lerp(focusPoint, focusPointTarget, Time.deltaTime);

			if (diffCount > differenceRefreshTreshold * colorArray.Length) {
				textureDiff.SetPixels(colorArray);
				textureDiff.Apply(false);
			}
		}
	}
}
