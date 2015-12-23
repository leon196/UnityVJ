using UnityEngine;
using System.Collections;

[ExecuteInEditMode]
public class SplashesDiff : Filter 
{
	void Awake ()
	{
		material = new Material( Shader.Find("Hidden/SplashesDiff") );
	}
}