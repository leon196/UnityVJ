using UnityEngine;
using System.Collections;

[ExecuteInEditMode]
public class distortEffect : MonoBehaviour
{
	public Material material;
	public float deform;
	public float gain;


	void Update() {

		material.SetFloat("_deform", deform);
		material.SetFloat("_gain", gain);

	}

	// Postprocess the image
	void OnRenderImage(RenderTexture source, RenderTexture destination)
	{
		Graphics.Blit(source, destination, material);
	}
}