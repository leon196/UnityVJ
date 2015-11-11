using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class SwitchCamera : MonoBehaviour
{
	List<Camera> cameraList;
	BufferTexture bufferTexture;
	int currentCamera;
	public RenderTexture bufferPlaceHolder;

	void Start ()
	{
		currentCamera = 0;
		cameraList = new List<Camera>();
		Camera[] cameraArray = FindObjectsOfType<Camera>();
		foreach (Camera camera in cameraArray) {
			if (camera.tag != "MainCamera") {
				cameraList.Add(camera);
			}
		}
		bufferTexture = FindObjectOfType<BufferTexture>();
	}

	void Update ()
	{
		if (Input.GetKeyDown(KeyCode.Space)) {
			Switch();
		}
	}

	void Switch ()
	{
		bufferTexture.cameraBuffer.targetTexture = bufferPlaceHolder;
		bufferTexture.cameraBuffer = cameraList[currentCamera];
		currentCamera = (currentCamera + 1) % cameraList.Count;
	}
}
