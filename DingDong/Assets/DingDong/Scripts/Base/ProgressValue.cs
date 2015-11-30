using UnityEngine;
using System.Collections;

public class ProgressValue
{
	float valueFrom;
	float valueTo;
	float progressStart;
	float progressDelay;
	float timeStart;
	public ProgressValue (float from_, float to_, float start_, float delay_)
	{
		valueFrom = from_;
		valueTo = to_;
		progressStart = start_;
		progressDelay = delay_;
	}
	public void Start ()
	{
		timeStart = Time.time;
	}
	public float GetRatio ()
	{
		return Mathf.Clamp((Time.time - timeStart - progressStart) / progressDelay, 0f, 1f);
	}
	public float GetValue ()
	{
		return Mathf.Lerp(valueFrom, valueTo, GetRatio());
	}
	public void Debug ()
	{
		timeStart = Mathf.Infinity;
	}
}