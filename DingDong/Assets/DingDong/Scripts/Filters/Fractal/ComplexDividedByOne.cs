using UnityEngine;
using System.Collections;

[ExecuteInEditMode]
public class ComplexDividedByOne : Filter 
{
	void Awake ()
	{
		material = new Material( Shader.Find("Hidden/ComplexDividedByOne") );
	}
}