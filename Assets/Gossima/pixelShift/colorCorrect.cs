using UnityEngine;
using System.Collections;

[ExecuteInEditMode]
public class colorCorrect : MonoBehaviour 
{
	protected Material material;

	public float black = 0.0f;
	public float gamma = 1.0f;
	public float gain = 1.0f;
	
	// Creates a private material used to the effect
	void Awake ()
	{
		material = new Material( Shader.Find("colorCorrect") );
	}

	void Update() {		
		material.SetFloat("_black", black);
		material.SetFloat("_gain", gain);
		material.SetFloat("_gamma", gamma);	
	}
	
	// Postprocess the image
	void OnRenderImage (RenderTexture source, RenderTexture destination)
	{
		Graphics.Blit (source, destination, material);
	}
}

