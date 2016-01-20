using UnityEngine;
using System.Collections;

public class Buffer : MonoBehaviour
{
	public Camera cameraBuffer;
	public Material materialRender;

	float pixelSize = 1f;
	int currentTexture;
	RenderTexture[] textures;


	Texture2D textureBuffer;
	Color[] colorArray;

	void Start ()
	{
		
		int width = (int)(Screen.width * (1f / pixelSize));
		int height = (int)(Screen.height * (1f / pixelSize));
		currentTexture = 0;
		textures = new RenderTexture[2];
		CreateTextures();
		textureBuffer = new Texture2D(width, height, TextureFormat.ARGB32, true );
		colorArray = new Color[width * height];
		for (int i = 0; i < colorArray.Length; ++i) {
			colorArray[i] = Color.black;
		}
		textureBuffer.SetPixels(colorArray);
		textureBuffer.Apply();


	}

	void Update ()
	{
		int width = (int)(Screen.width * (1f / pixelSize));
		int height = (int)(Screen.height * (1f / pixelSize));
		Shader.SetGlobalVector("_screenSize", new Vector4(width,height,0,0));
		Shader.SetGlobalTexture("_TextureBuffer", GetCurrentTexture());
		NextTexture();
		cameraBuffer.targetTexture = GetCurrentTexture();
		materialRender.mainTexture = GetCurrentTexture();

		//Color[] colorPrevious = textures[currentTexture].GetPixels();
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