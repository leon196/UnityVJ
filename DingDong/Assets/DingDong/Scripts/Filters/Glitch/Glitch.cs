using UnityEngine;
using System.Collections;

[ExecuteInEditMode]
public class Glitch : Filter 
{
	void Awake ()
	{
		material = new Material( Shader.Find("Hidden/Glitch") );
	}
}