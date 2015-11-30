using UnityEngine;
using System.Collections;

[ExecuteInEditMode]
public class Crystal : Filter 
{
	void Awake ()
	{
		material = new Material( Shader.Find("Hidden/Crystal") );
	}
}