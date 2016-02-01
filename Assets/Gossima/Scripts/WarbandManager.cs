using UnityEngine;
using System.Collections;

public class WarbandManager : MonoBehaviour {

	public void RumbleCamera ()
	{
		transform.localPosition = new Vector3(Random.Range(-2f, 2f), Random.Range(-2f, 2f), Random.Range(-2f, 2f));
		transform.LookAt(transform.parent.position);
	}
}
