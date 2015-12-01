using UnityEngine;
using System.Collections;

[ExecuteInEditMode]
public class DirectionColor : Persistence 
{
	void Awake ()
	{
		material = new Material( Shader.Find("Hidden/DirectionColor") );
	}
}