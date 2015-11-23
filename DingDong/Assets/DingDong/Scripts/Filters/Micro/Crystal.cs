using UnityEngine;
using System.Collections;

[ExecuteInEditMode]
public class Crystal : MonoBehaviour 
{
	Material material;

	// Creates a private material used to the effect
	void Awake ()
	{
		material = new Material( Shader.Find("Hidden/Crystal") );
	}
	
	// Postprocess the image
	void OnRenderImage (RenderTexture source, RenderTexture destination)
	{
		Graphics.Blit (source, destination, material);
	}
}