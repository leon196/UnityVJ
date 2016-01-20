using UnityEngine;
using System.Collections;

[ExecuteInEditMode]
public class GradientFilter : Filter 
{
	public Color colorA;
	public Color colorB;
	public Color colorC;

	void Awake ()
	{
		material = new Material( Shader.Find("Hidden/Gradient") );
		material.SetColor("_ColorA", colorA);
		material.SetColor("_ColorB", colorB);
		material.SetColor("_ColorC", colorC);
	}

	void OnRenderImage (RenderTexture source, RenderTexture destination)
	{
		material.SetColor("_ColorA", colorA);
		material.SetColor("_ColorB", colorB);
		material.SetColor("_ColorC", colorC);
		Graphics.Blit (source, destination, material);
	}
}