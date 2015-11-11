using UnityEngine;
using System.Collections;

public class Translate : MonoBehaviour
{
	public float length = 5f;
	public float speed = 1f;
	public Vector3 axe = Vector3.forward;

	void Update ()
	{
		transform.position = axe.normalized * Mathf.Sin(Time.time * speed) * length;
	}
}
