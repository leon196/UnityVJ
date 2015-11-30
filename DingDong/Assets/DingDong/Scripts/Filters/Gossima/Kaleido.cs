using UnityEngine;
using System.Collections;

[ExecuteInEditMode]
public class Kaleido : Filter 
{
	void Awake ()
	{
		material = new Material( Shader.Find("Hidden/Kaleido") );
	}
}