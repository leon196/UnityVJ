using UnityEngine;
using System.Collections;

[ExecuteInEditMode]
public class Gradient : Filter 
{
	public Color colorA;
	public Color colorB;

	void Awake ()
	{
		material = new Material( Shader.Find("Hidden/Gradient") );
		material.SetColor("_ColorA", colorA);
		material.SetColor("_ColorB", colorB);
	}

	void OnRenderImage (RenderTexture source, RenderTexture destination)
	{
		material.SetColor("_ColorA", colorA);
		material.SetColor("_ColorB", colorB);
		Graphics.Blit (source, destination, material);
	}
}