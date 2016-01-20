using UnityEngine;
using System.Collections;

[ExecuteInEditMode]
public class BlackWhite : Filter 
{
	void Awake ()
	{
		material = new Material( Shader.Find("Hidden/BlackWhite") );
	}
}