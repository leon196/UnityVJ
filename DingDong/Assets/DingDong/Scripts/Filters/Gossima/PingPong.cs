using UnityEngine;
using System.Collections;

[ExecuteInEditMode]
public class PingPong : Filter 
{
	void Awake ()
	{
		material = new Material( Shader.Find("Hidden/PingPong") );
	}
}
