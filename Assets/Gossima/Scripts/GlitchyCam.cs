using UnityEngine;
using System.Collections;

[ExecuteInEditMode]
public class GlitchyCam : Filter
{
	public float deform;
	public float gain;
	public float intensity;
	
	void Awake ()
	{
		material = new Material( Shader.Find("glitchyCam") );
	}

	void Update() {
		material.SetFloat("_deform", deform);
		material.SetFloat("_gain", gain);
		material.SetFloat("_intensity", intensity);
	}
}