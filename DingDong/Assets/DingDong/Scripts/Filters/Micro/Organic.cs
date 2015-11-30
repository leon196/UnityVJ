using UnityEngine;
using System.Collections;

[ExecuteInEditMode]
public class Organic : Filter 
{
	void Awake ()
	{
		material = new Material( Shader.Find("Hidden/Organic") );
	}
}