using UnityEngine;
using System.Collections;

public class PingPongManager : MonoBehaviour {

	ParticleSystem emitter;
	WebcamManager webcam;
	public Transform bonus;
	public Transform focus;
	public Camera cameraParticles;
	public float targetRadius = 1f;

	void Start () {
		emitter = GameObject.FindObjectOfType<ParticleSystem>();
		webcam = GameObject.FindObjectOfType<WebcamManager>();
		RandomPoint();
	}
	
	void Update () {

		// focus.transform.position = cameraParticles.ViewportToWorldPoint(new Vector3(webcam.focusPoint.x, webcam.focusPoint.y, 1f));

		if (webcam.pixelTouchedTarget) {
			emitter.transform.position = bonus.transform.position;
			RandomPoint();
			emitter.Emit(18);
		}	
	}

	void RandomPoint () {
		float x = Random.Range(0f, 1f);
		float y = Random.Range(0f, 1f);
		bonus.transform.position = cameraParticles.ViewportToWorldPoint(new Vector3(x, y, 1f));
		webcam.targetPoint = new Vector2(x, y);
	}
}
