using UnityEngine;
using System.Collections;

[ExecuteInEditMode]
public class Fire : Filter 
{
	void Awake ()
	{
		material = new Material( Shader.Find("Hidden/Fire") );
	}
}
