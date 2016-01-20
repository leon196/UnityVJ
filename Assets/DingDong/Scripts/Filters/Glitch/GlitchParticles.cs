using UnityEngine;
using System.Collections;

[ExecuteInEditMode]
public class GlitchParticles : Filter 
{
	void Awake ()
	{
		material = new Material( Shader.Find("Hidden/GlitchParticles") );
	}
}
