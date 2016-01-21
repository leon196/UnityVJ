using UnityEngine;
using System.Collections;

[ExecuteInEditMode]
public class Fractal : Filter 
{
	void Awake ()
	{
		material = new Material( Shader.Find("Hidden/Fractal") );
	}
}