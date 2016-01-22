using UnityEngine;
using System.Collections;

[ExecuteInEditMode]
public class Splashes : Filter 
{
	float currentSpeed;
	float currentDirectionColorRatio;

	void Awake ()
	{
		material = new Material( Shader.Find("Hidden/Splashes") );
		currentSpeed = material.GetFloat("_Speed");
		currentDirectionColorRatio = material.GetFloat("_DirectionColorRatio");
	}

	public void UpSpeed ()
	{
		currentSpeed = Mathf.Clamp(currentSpeed + Time.deltaTime, 0.01f, 1f);
		SetSpeed(currentSpeed);
	}

	public void DownSpeed ()
	{
		currentSpeed = Mathf.Clamp(currentSpeed - Time.deltaTime, 0.01f, 1f);
		SetSpeed(currentSpeed);
	}

	public void SetSpeed (float speed) 
	{
		currentSpeed = Mathf.Clamp(speed, 0.01f, 1f);;
		material.SetFloat("_Speed", currentSpeed);
	}

	public void UpDirectionColorRatio ()
	{
		currentDirectionColorRatio = Mathf.Clamp(currentDirectionColorRatio + Time.deltaTime, 0.01f, 1f);
		SetDirectionColorRatio(currentDirectionColorRatio);
	}

	public void DownDirectionColorRatio ()
	{
		currentDirectionColorRatio = Mathf.Clamp(currentDirectionColorRatio - Time.deltaTime, 0.01f, 1f);
		SetDirectionColorRatio(currentDirectionColorRatio);
	}

	public void SetDirectionColorRatio (float ratio) 
	{
		currentDirectionColorRatio = Mathf.Clamp(ratio, 0f, 1f);;
		material.SetFloat("_DirectionColorRatio", currentDirectionColorRatio);
	}
}