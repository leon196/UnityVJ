using UnityEngine;
using System.Collections;

[ExecuteInEditMode]
public class ZooMachines : Filter 
{
	void Awake ()
	{
		material = new Material( Shader.Find("Hidden/ZooMachines") );
	}
}