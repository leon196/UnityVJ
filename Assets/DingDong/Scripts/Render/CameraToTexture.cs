using UnityEngine;
using System.Collections;

public class CameraToTexture : MonoBehaviour
{
	RenderTexture buffer;
	
	void Start ()
	{
		buffer = new RenderTexture(Screen.width, Screen.height, 24, RenderTextureFormat.ARGB32);
		buffer.antiAliasing = 2;
		buffer.Create();
		GetComponent<Camera>().targetTexture = buffer;
		Shader.SetGlobalTexture("_CameraTexture", buffer);
	}
}