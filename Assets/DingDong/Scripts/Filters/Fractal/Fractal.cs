using UnityEngine;
using System.Collections;

[ExecuteInEditMode]
public class Fractal : Filter 
{
	float currentZoom = 1f;

	void Awake ()
	{
		material = new Material( Shader.Find("Hidden/Fractal") );
	}

	public void ToggleFractalMode ()
	{
		material.SetFloat("_FractalMode", material.GetFloat("_FractalMode") == 0f ? 1f : 0f);
	}

	public void SetFractalMode (float mode)
	{
		material.SetFloat("_FractalMode", mode);
	}

	public void UpZoom ()
	{
		currentZoom = Mathf.Clamp(currentZoom + Time.deltaTime * 0.1f, 0.001f, 100f);
		SetZoom(currentZoom);
	}

	public void DownZoom ()
	{
		currentZoom = Mathf.Clamp(currentZoom - Time.deltaTime * 0.1f, 0.001f, 100f);
		SetZoom(currentZoom);
	}

	public void SetZoom (float zoom)
	{
		currentZoom = Mathf.Clamp(zoom, 0.001f, 100f);
		material.SetFloat("_Zoom", currentZoom);
	}

	public void ToggleMoveX ()
	{
		material.SetFloat("_MoveX", material.GetFloat("_MoveX") == 0f ? 1f : 0f);
	}

	public void ToggleMoveY ()
	{
		material.SetFloat("_MoveY", material.GetFloat("_MoveY") == 0f ? 1f : 0f);
	}
}