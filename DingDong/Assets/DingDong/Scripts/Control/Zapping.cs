using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class Zapping : MonoBehaviour 
{
	// Filter[] filterList;
	List<Filter[]> filterList;
	Camera[] cameraList;

	void Start () 
	{
		filterList = new List<Filter[]>();
		cameraList = Resources.FindObjectsOfTypeAll<Camera>();
		int c = 0;
		foreach (Camera camera in cameraList)
		{
			filterList.Add(camera.GetComponentsInChildren<Filter>(true));
			++c;
		}
	}

	public void Zap ()
    {
        Clear();
		Shuffle();
	}

	public void Clear ()
	{
		foreach (Camera camera in cameraList)
		{
			Filter[] filters = camera.GetComponentsInChildren<Filter>() as Filter[];
			foreach (Filter filter in filters)
			{
	            Destroy(filter);
			}
		}
	}

	void Shuffle ()
	{
		int c = 0;
		foreach (Camera camera in cameraList)
		{
			Filter[] filters = filterList[c];

			for (int i = filters.Length - 1; i > 0; i--)
			{
				int j = (int)Mathf.Floor(Random.Range(0f, 1f) * ((float)i + 1f));
				Filter temp = filters[i];
				filters[i] = filters[j];
				filters[j] = temp;
			}
			foreach (Filter filter in filters)
			{
				Filter newFilter = camera.gameObject.AddComponent(filter.GetType()) as Filter;
				newFilter.enabled = Random.Range(0f, 1f) < 0.5f;
				newFilter.Rumble();
			}

			++c;
		}
	}
}
