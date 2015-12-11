using UnityEngine;
using System.Collections;

[ExecuteInEditMode]
public class DirectionColor : Filter 
{
	void Awake ()
	{
		material = new Material( Shader.Find("Hidden/DirectionColor") );
	}
}
