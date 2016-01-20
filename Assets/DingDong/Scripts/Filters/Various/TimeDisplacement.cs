using UnityEngine;
using System.Collections;

[ExecuteInEditMode]
public class TimeDisplacement : Filter 
{
	void Awake ()
	{
		material = new Material( Shader.Find("Hidden/TimeDisplacement") );
	}
}
