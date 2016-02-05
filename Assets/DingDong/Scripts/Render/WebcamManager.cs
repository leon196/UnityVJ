using UnityEngine;
using System.Collections;

public class WebcamManager : MonoBehaviour {

	public Material materialWebcam;
	public WebCamTexture texture;

	void Awake () {
		if (WebCamTexture.devices.Length > 0) {

			// Setup webcam texture
			texture = new WebCamTexture();
			texture.Play();
			texture.filterMode = FilterMode.Point;
			Shader.SetGlobalTexture("_WebcamTexture", texture);
			if (materialWebcam != null) {
				materialWebcam.mainTexture = texture;
			}
		}
	}
}
