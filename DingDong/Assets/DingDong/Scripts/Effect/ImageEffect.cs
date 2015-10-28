using UnityEngine;
using System.Collections;

[ExecuteInEditMode]
public class ImageEffect : MonoBehaviour {

	public float intensity;
	private Material material;

	// Creates a private material used to the effect
	void Awake ()
	{
		material = new Material( Shader.Find("Hidden/ComplexDistortion") );
	}

	// Postprocess the image
	void OnRenderImage (RenderTexture source, RenderTexture destination)
	{
		material.SetFloat("_bwBlend", intensity);
		Graphics.Blit (source, destination, material);
	}
}
