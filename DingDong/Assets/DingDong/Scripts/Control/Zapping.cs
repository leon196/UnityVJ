using UnityEngine;
using System.Collections;

public class Zapping : MonoBehaviour 
{
	Filter[] filterList;

	void Start () 
	{
		filterList = GetComponentsInChildren<Filter>(true) as Filter[];
	}

	public void Zap ()
    {
        Clear();
		Shuffle();
	}

	public void Clear ()
	{
		filterList = GetComponentsInChildren<Filter>(true) as Filter[];
		foreach (Filter filter in filterList)
		{
            Destroy(filter);
		}
	}

	void Shuffle ()
	{
		for (int i = filterList.Length - 1; i > 0; i--)
		{
			int j = (int)Mathf.Floor(Random.Range(0f, 1f) * ((float)i + 1f));
			Filter temp = filterList[i];
			filterList[i] = filterList[j];
			filterList[j] = temp;
		}

		foreach (Filter filter in filterList)
		{
			Filter newFilter = gameObject.AddComponent(filter.GetType()) as Filter;
			newFilter.enabled = Random.Range(0f, 1f) < 0.5f;
			newFilter.Rumble();
		}
	}
}
