using UnityEngine;
using System.Collections;

[ExecuteInEditMode]
public class GlitchScanline : Filter 
{
	void Awake ()
	{
		material = new Material( Shader.Find("Hidden/GlitchScanline") );
	}
}
