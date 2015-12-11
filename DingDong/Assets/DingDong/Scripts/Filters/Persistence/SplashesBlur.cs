using UnityEngine;
using System.Collections;

[ExecuteInEditMode]
public class SplashesBlur : Filter 
{
	void Awake ()
	{
		material = new Material( Shader.Find("Hidden/SplashesBlur") );
	}
}
