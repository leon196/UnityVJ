using UnityEngine;
using System.Collections;

namespace DingDong
{
	[RequireComponent (typeof (Camera))]
	public class RenderTexture : MonoBehaviour
	{
		public int pixelSize = 1;
		public UnityEngine.RenderTexture texture;
		public Material material;

		Camera cameraEffect;
		Material materialEffect;

		int currentTexture;
		UnityEngine.RenderTexture[] textures;

		void NextTexture ()
		{
			currentTexture = (currentTexture + 1) % 2;
		}

		UnityEngine.RenderTexture GetCurrentTexture ()
		{
			return textures[currentTexture];
		}

		void Start ()
		{
			// currentTexture = 0;
			// textures = new UnityEngine.RenderTexture[2];
			// Resize();
			//
			// cameraRender = GetComponent<Camera>();
			// materialRender = GetComponentInChildren<Renderer>().material;
			//
			// cameraEffect = Camera.main;
			// materialEffect = cameraEffect.GetComponentInChildren<Renderer>().material;
			//
			// UnityEngine.Shader.SetGlobalTexture("_SamplerRenderTarget", GetCurrentTexture());
			// NextTexture();
			// cameraRender.targetTexture = GetCurrentTexture();
			// materialEffect.mainTexture = GetCurrentTexture();

		}

		void Update ()
		{
			// UnityEngine.Shader.SetGlobalTexture("_SamplerRenderTarget", GetCurrentTexture());
			// NextTexture();
			// cameraRender.targetTexture = GetCurrentTexture();
			// materialEffect.mainTexture = GetCurrentTexture();
		}

		public void Resize ()
		{
			// int width = (int)(Screen.width * (1f / pixelSize));
			// int height = (int)(Screen.height * (1f / pixelSize));
			//
			// for (int i = 0; i < textures.Length; ++i)
			// {
			// 	if (textures[i])
			// 	{
			// 		textures[i].Release();
			// 	}
			// 	textures[i] = new UnityEngine.RenderTexture(width, height, 16, RenderTextureFormat.ARGB32);
			// 	textures[i].Create();
			// 	textures[i].filterMode = FilterMode.Point;
			// }
		}
	}
}
