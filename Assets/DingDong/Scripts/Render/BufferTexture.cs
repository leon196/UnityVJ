using UnityEngine;
using System.Collections;

public class BufferTexture : MonoBehaviour
{
	public Camera cameraRender;
	public Camera cameraBuffer;
	public Material materialBuffer;
	public Material materialPostRender;

	float pixelSize = 1f;
	int currentTexture;
	RenderTexture[] textures;
	RenderTexture textureBaked;

	void Start ()
	{
		// Double Buffer
		currentTexture = 0;
		textures = new RenderTexture[2];
		CreateTextures();

		// Post render
		textureBaked = new RenderTexture((int)Screen.width, (int)Screen.height, 24, RenderTextureFormat.ARGB32);
		textureBaked.Create();
		textureBaked.filterMode = FilterMode.Point;
		cameraRender.targetTexture = textureBaked;
		materialPostRender.mainTexture = textureBaked;
	}

	void Update ()
	{
		Shader.SetGlobalTexture("_BufferTexture", GetCurrentTexture());
		NextTexture();
		cameraBuffer.targetTexture = GetCurrentTexture();
		materialBuffer.mainTexture = GetCurrentTexture();
	}

	void NextTexture ()
	{
		currentTexture = (currentTexture + 1) % 2;
	}

	RenderTexture GetCurrentTexture ()
	{
		return textures[currentTexture];
	}

	void CreateTextures ()
	{
		int width = (int)(Screen.width * (1f / pixelSize));
		int height = (int)(Screen.height * (1f / pixelSize));

		for (int i = 0; i < textures.Length; ++i) {
			if (textures[i]) {
				textures[i].Release();
			}
			textures[i] = new RenderTexture(width, height, 24, RenderTextureFormat.ARGB32);
			textures[i].Create();
			textures[i].filterMode = FilterMode.Point;
		}
	}
}