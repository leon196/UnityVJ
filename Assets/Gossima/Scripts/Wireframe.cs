using UnityEngine;
using System.Collections;

public class Wireframe : MonoBehaviour 
{
	public Material material;
	public int tesselate = 2;

	void OnPreRender () 
	{
		GL.wireframe = true;
	}

	void OnPostRender () 
	{
		GL.wireframe = false;
	}
}