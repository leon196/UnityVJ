using UnityEngine;
using System.Collections;

[ExecuteInEditMode]
public class Splashes : Filter 
{
	void Awake ()
	{
		material = new Material( Shader.Find("Hidden/Splashes") );
	}
}