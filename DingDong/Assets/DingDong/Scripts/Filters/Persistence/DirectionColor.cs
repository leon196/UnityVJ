using UnityEngine;
using System.Collections;

[ExecuteInEditMode]
public class DirectionColor : Filter 
{
	public float persistenceTreshold = 0.5f;

	void Awake ()
	{
		material = new Material( Shader.Find("Hidden/DirectionColor") );
	}

	public override void Rumble ()
	{
		persistenceTreshold = Random.Range(0.5f, 0.95f);
		material.SetFloat("_PersistenceTreshold", persistenceTreshold);
	}
}