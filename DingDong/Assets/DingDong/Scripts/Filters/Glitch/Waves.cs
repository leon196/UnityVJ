using UnityEngine;
using System.Collections;

[ExecuteInEditMode]
public class Waves : Filter 
{
	void Awake ()
	{
		material = new Material( Shader.Find("Hidden/Waves") );
	}
}
