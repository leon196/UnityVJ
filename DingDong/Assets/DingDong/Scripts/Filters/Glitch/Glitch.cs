using UnityEngine;
using System.Collections;

[ExecuteInEditMode]
public class Glitch : Persistence 
{
	void Awake ()
	{
		material = new Material( Shader.Find("Hidden/Glitch") );
	}
}