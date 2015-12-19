using UnityEngine;
using System.Collections;

public class WebcamTexture : MonoBehaviour {

	WebCamTexture textureWebcam;
	public Material material;

	void Start () {

		if (WebCamTexture.devices.Length > 0) {
			// Setup webcam texture
			textureWebcam = new WebCamTexture();
			Shader.SetGlobalTexture("_WebcamTexture", textureWebcam);
			textureWebcam.Play();
			if (material != null) {
				material.mainTexture = textureWebcam;
			}
		}
	}
	
	void Update () {
	
	}
}
