using UnityEngine;
using System.Collections;

[ExecuteInEditMode]
public class WireframeFilter : Filter 
{
	void Awake ()
	{
		material = new Material( Shader.Find("Hidden/WireframeFilter") );
	}
}