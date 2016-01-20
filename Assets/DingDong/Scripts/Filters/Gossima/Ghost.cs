using UnityEngine;
using System.Collections;

[ExecuteInEditMode]
public class Ghost : Filter 
{
	void Awake ()
	{
		material = new Material( Shader.Find("Hidden/Ghost") );
	}
}