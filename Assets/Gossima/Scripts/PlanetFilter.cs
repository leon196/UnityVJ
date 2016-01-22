using UnityEngine;
using System.Collections;

[ExecuteInEditMode]
public class PlanetFilter : Filter 
{
	void Awake ()
	{
		material = new Material( Shader.Find("Hidden/PlanetFilter") );
	}
}