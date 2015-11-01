using UnityEngine;
using System.Collections;

public class RotateY : MonoBehaviour {

	public float speed = 4f;

	// Use this for initialization
	void Start () {

	}

	void Update ()
	{
		this.transform.Rotate(Vector3.up * Time.deltaTime * this.speed);
	}
}
