using UnityEngine;
using System.Collections;
using System.Collections.Generic;

class ZapState 
{
	public int indexCamera;
	public int indexFilter;
	public bool shouldClear;
	public bool shouldAdd;
	public bool shouldRumble;

	public ZapState (int iCamera, int iFitler)
	{
		indexCamera = iCamera;
		indexFilter = iFitler;
		shouldClear = true;
		shouldAdd = true;
		shouldRumble = true;
	}
}

public class Zapping : MonoBehaviour 
{
	Camera[] cameraList;
	List<Filter[]> filterList;
	List<List<ZapState>> zapStateList;

	void Start () 
	{
		filterList = new List<Filter[]>();
		zapStateList = new List<List<ZapState>> ();
		cameraList = FindObjectsOfType<Camera>();
		int c = 0;
		foreach (Camera camera in cameraList)
		{
			filterList.Add(camera.GetComponentsInChildren<Filter>(true));
			zapStateList.Add(new List<ZapState>());
			int f = 0;
			foreach (Filter filter in filterList[c]) {
				ZapState zapState = new ZapState(c, f);
				// if (filter.always) {
				// 	zapState.shouldAdd = false;
				// 	zapState.shouldClear = false;
				// }
				zapStateList[c].Add(zapState);
				++f;
			}
			++c;
		}
	}

	void Update ()
	{
		if (Input.GetKeyDown(KeyCode.R)) {
			Zap();
		}
	}

	public void Zap ()
    {
        // Clear();
		// Shuffle();
		Rumble();
	}

	public void Rumble ()
	{
		int c = 0;
		foreach (Camera camera in cameraList)
		{
			int f = 0;
			Filter[] filters = camera.GetComponentsInChildren<Filter>() as Filter[];
			foreach (Filter filter in filters)
			{
				filter.Rumble();
				++f;
			}
		}
		++c;
	}

	public void Clear ()
	{
		int c = 0;
		foreach (Camera camera in cameraList)
		{
			int f = 0;
			filterList[c] = camera.GetComponentsInChildren<Filter>() as Filter[];
			foreach (Filter filter in filterList[c])
			{
				ZapState zapState = zapStateList[c][f];
				if (zapState.shouldClear) {
	            	Destroy(filter);
				}
				++f;
			}
			++c;
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
				ZapState tempZ = zapStateList[c][i];
				filters[i] = filters[j];
				zapStateList[c][i] = zapStateList[c][j];
				zapStateList[c][i].indexFilter = j;
				filters[j] = temp;
				zapStateList[c][j] = tempZ;
				zapStateList[c][j].indexFilter = i;
			}

			int f = 0;
			foreach (Filter filter in filters)
			{
				ZapState zapState = zapStateList[c][f];
				if (zapState.shouldAdd) {
					// Filter newFilter = camera.gameObject.AddComponent(filter.GetType()) as Filter;
					// newFilter.enabled = Random.Range(0f, 1f) < 0.5f;
				}
				if (zapState.shouldRumble) {
					Filter currentFilter = filterList[zapState.indexCamera][zapState.indexFilter];
					currentFilter.Rumble();
				}
				++f;
			}
			++c;
		}
	}
}
