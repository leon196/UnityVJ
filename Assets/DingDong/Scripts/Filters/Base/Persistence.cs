using UnityEngine;
using System.Collections;

[ExecuteInEditMode]
public class Persistence : Filter 
{
	public float treshold = 0.5f;

	void Start ()
	{
		material.SetFloat("_PersistenceTreshold", treshold);
	}

	public override void Rumble ()
	{
		treshold = Random.Range(0.5f, 0.75f);
		material.SetFloat("_PersistenceTreshold", treshold);
	}
}