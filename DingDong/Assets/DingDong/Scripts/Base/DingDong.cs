using UnityEngine;
using System.Collections;

namespace DingDong {
	public class DingDong : MonoBehaviour {

		public Camera cameraEffect;
		int currentFilter = 0;
		Filter[] filterArray;
		float delay = 10f;
		float lastTime;

		void Start () {
			Cursor.visible = false;
			lastTime = Time.time;
			filterArray = cameraEffect.GetComponents<Filter>();
			for (int i = 0; i < filterArray.Length; ++i) {
				Filter filter = filterArray[i];
				if (filter.enabled) {
					currentFilter = i;
					break;
				}
			}
		}

		void Update () {
			bool shouldNext = Input.GetKeyDown(KeyCode.Space) || Input.GetMouseButtonDown(0);
			shouldNext = shouldNext || lastTime + delay < Time.time;
			if (shouldNext) {
				NextFilter();
				lastTime = Time.time;
			}
			if (Input.GetKeyDown(KeyCode.Escape)) {
				Application.Quit();
			}
		}

		void NextFilter () {
			currentFilter = (currentFilter + 1) % filterArray.Length;
			for (int i = 0; i < filterArray.Length; ++i) {
				Filter filter = filterArray[i];
				if (i != currentFilter) {
					filter.enabled = false;
				} else {
					filter.enabled = true;
				}
			}
		}
	}
}
