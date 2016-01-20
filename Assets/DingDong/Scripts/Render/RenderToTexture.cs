using UnityEngine;
using System.Collections;

public class RenderToTexture : MonoBehaviour
{
	public string uniformName = "_Texture";
	RenderTexture texture;
	
	void Start ()
	{
		texture = new RenderTexture((int)Screen.width, (int)Screen.height, 24, RenderTextureFormat.ARGB32);
		texture.Create();
		texture.filterMode = FilterMode.Point;
		GetComponent<Camera>().targetTexture = texture;
		Shader.SetGlobalTexture(uniformName, texture);
	}
}