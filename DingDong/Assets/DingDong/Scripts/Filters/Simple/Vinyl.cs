using UnityEngine;
using System.Collections;

[ExecuteInEditMode]
public class Vinyl : Filter 
{
	void Awake ()
	{
		material = new Material( Shader.Find("Hidden/Vinyl") );
	}
}