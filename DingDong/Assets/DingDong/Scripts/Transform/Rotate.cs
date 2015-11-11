using UnityEngine;
using System.Collections;

public class Rotate : MonoBehaviour
{
	public float speed = 1f;
	public Vector3 axe = Vector3.up;
	public Space space =  Space.World;

	void Update ()
	{
		this.transform.Rotate(axe.normalized * Time.deltaTime * speed, space);
	}
}
