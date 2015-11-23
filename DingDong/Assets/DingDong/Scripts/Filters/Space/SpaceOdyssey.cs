using UnityEngine;
using System.Collections;

[ExecuteInEditMode]
public class SpaceOdyssey : MonoBehaviour 
{
	Material material;

	// Creates a private material used to the effect
	void Awake ()
	{
		material = new Material( Shader.Find("Hidden/SpaceOdyssey") );
	}
	
	// Postprocess the image
	void OnRenderImage (RenderTexture source, RenderTexture destination)
	{
		Graphics.Blit (source, destination, material);
	}
}