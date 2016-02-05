using UnityEngine;
using System.Collections;

[ExecuteInEditMode]
public class Kaleido : Filter 
{
	float currentSpeed = 10f;
	float currentKaleidoCount = 2f;

	void Awake ()
	{
		material = new Material( Shader.Find("Hidden/Kaleido") );
		currentSpeed = material.GetFloat("_Speed");
		currentKaleidoCount = material.GetFloat("_KaleidoCount");
	}

	public void Reset ()
	{
		currentSpeed = 10f;
		currentKaleidoCount = 2f;
		material.SetFloat("_Speed", currentSpeed);
		material.SetFloat("_KaleidoCount", currentKaleidoCount);
	}

	public void UpSpeed ()
	{
		currentSpeed = Mathf.Clamp(currentSpeed + Time.deltaTime, 0f, 100f);
		SetSpeed(currentSpeed);
	}

	public void DownSpeed ()
	{
		currentSpeed = Mathf.Clamp(currentSpeed - Time.deltaTime, 0f, 100f);
		SetSpeed(currentSpeed);
	}

	public void SetSpeed (float speed)
	{
		currentSpeed = Mathf.Clamp(speed, 0f, 100f);
		material.SetFloat("_Speed", currentSpeed);
	}

	public void SetKaleidoCount (float count)
	{
		currentKaleidoCount = Mathf.Clamp(count, 1f, 100f);
		material.SetFloat("_KaleidoCount", currentKaleidoCount);
	}
}