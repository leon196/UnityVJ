using UnityEngine;
using System.Collections;

[ExecuteInEditMode]
public class Filter : MonoBehaviour 
{
	public bool always = false;
	public bool before = false;
	public bool after = false;
	protected Material material;

	// Creates a private material used to the effect
	void Awake ()
	{
		material = new Material( Shader.Find("Hidden/Gradient") );
	}
	
	// Postprocess the image
	void OnRenderImage (RenderTexture source, RenderTexture destination)
	{
		Graphics.Blit (source, destination, material);
	}

	public virtual void Rumble ()
	{
	}
}