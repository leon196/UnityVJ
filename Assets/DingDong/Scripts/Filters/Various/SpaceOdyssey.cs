using UnityEngine;
using System.Collections;

[ExecuteInEditMode]
public class SpaceOdyssey : Filter 
{
	void Awake ()
	{
		material = new Material( Shader.Find("Hidden/SpaceOdyssey") );
	}

	public void ToggleHorizontal ()
	{
		material.SetFloat("_Horizontal", material.GetFloat("_Horizontal") == 1f ? 0f : 1f);
	}
}