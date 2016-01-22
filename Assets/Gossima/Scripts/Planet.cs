using UnityEngine;
using System.Collections;

public class Planet : MonoBehaviour 
{
	Material material;
	[HideInInspector] public float uvScale;

	void Start ()
	{
		material = GetComponent<Renderer>().material;
		uvScale = material.GetFloat("_UVScale");
	}

	void Update ()
	{
		transform.Rotate(10f * Time.deltaTime * Vector3.up);
	}

	public void IncrementUVScale ()
	{
		uvScale = Mathf.Clamp(uvScale + 1, 1, 12);
		SetUVScale(uvScale);
	}

	public void DecrementUVScale ()
	{
		uvScale = Mathf.Clamp(uvScale - 1, 1, 12);
		SetUVScale(uvScale);
	}

	public void SetUVScale (float scale) 
	{
		uvScale = scale;
		material.SetFloat("_UVScale", uvScale);
	}
}