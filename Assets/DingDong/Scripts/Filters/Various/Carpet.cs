using UnityEngine;
using System.Collections;

[ExecuteInEditMode]
public class Carpet : Filter 
{
	void Awake ()
	{
		material = new Material( Shader.Find("Hidden/Carpet") );
	}
}