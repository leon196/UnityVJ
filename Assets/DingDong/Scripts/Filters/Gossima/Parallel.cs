using UnityEngine;
using System.Collections;

[ExecuteInEditMode]
public class Parallel : Filter 
{
	void Awake ()
	{
		material = new Material( Shader.Find("Hidden/Parallel") );
	}
}