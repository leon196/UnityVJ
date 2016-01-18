using UnityEngine;
using System.Collections;

[ExecuteInEditMode]
public class glitchyCam : MonoBehaviour
{
	public Material material;
	public float deform;
	public float gain;
	public float intensity;


	void Update() {

		material.SetFloat("_deform", deform);
		material.SetFloat("_gain", gain);
		material.SetFloat("_intensity", intensity);
		


	}

	// Postprocess the image
	void OnRenderImage(RenderTexture source, RenderTexture destination)
	{
		Graphics.Blit(source, destination, material);
	}
}