using UnityEngine;
using System.Collections;

[ExecuteInEditMode]
public class Kaleido3DFilter : Filter 
{
	void Awake ()
	{
		material = new Material( Shader.Find("Hidden/Kaleido3DFilter") );
	}
}