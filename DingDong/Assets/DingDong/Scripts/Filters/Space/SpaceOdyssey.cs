using UnityEngine;
using System.Collections;

[ExecuteInEditMode]
public class SpaceOdyssey : Filter 
{
	void Awake ()
	{
		material = new Material( Shader.Find("Hidden/SpaceOdyssey") );
	}
}