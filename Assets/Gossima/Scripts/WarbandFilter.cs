using UnityEngine;
using System.Collections;

[ExecuteInEditMode]
public class WarbandFilter : Filter 
{
	void Awake ()
	{
		material = new Material( Shader.Find("Hidden/WarbandFilter") );
	}
}
