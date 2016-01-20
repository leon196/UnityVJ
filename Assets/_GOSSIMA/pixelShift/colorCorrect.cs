using UnityEngine;
using System.Collections;

[ExecuteInEditMode]
public class colorCorrect : MonoBehaviour {

	public Material material;

	public float black = 0.0f;
	public float white = 1.0f;
	public float gamma = 1.0f;
	public float gain = 1.0f;
	public float saturation = 1.0f;
	
	
	void Update() {
		
		material.SetFloat("_black", black);
		material.SetFloat("_white", white);
		material.SetFloat("_gain", gain);
		material.SetFloat("_gamma", gamma);
		material.SetFloat("_saturation", saturation);
		
	}
	
	// Postprocess the image
	void OnRenderImage(RenderTexture source, RenderTexture destination)
	{
		Graphics.Blit(source, destination, material);
	}
}
