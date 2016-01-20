using UnityEngine;
using System;
using System.Collections;

namespace DingDong {
	public class DingDong : MonoBehaviour {

		public Camera cameraEffect;
		int currentFilter = 0;
		Filter[] filterArray;
		public float delay = 10f;
		float lastTime;
		Type currentFilterType = typeof(ComplexDividedByOne);
		int kaleidoCount = 1;

		void Start () {
#if !UNITY_EDITOR
			Cursor.visible = false;
#endif
			lastTime = Time.time;
			filterArray = cameraEffect.GetComponents<Filter>();
			for (int i = 0; i < filterArray.Length; ++i) {
				Filter filter = filterArray[i];
				if (filter.enabled) {
					currentFilter = i;
					break;
				}
			}

			SelectKaleidoCount(1);
		}

		void Update () {
			bool shouldNext = Input.GetKeyDown(KeyCode.Space) || Input.GetMouseButtonDown(0);
			//shouldNext = shouldNext || lastTime + delay < Time.time;
			if (shouldNext) {
				NextFilter();
				lastTime = Time.time;
			}
			if (Input.GetKeyDown(KeyCode.Escape)) {
				Application.Quit();
			}

			if (Input.GetKeyDown(KeyCode.A)) {
				SelectFilter(typeof(ComplexDividedByOne));
			} else if (Input.GetKeyDown(KeyCode.B)) {
				SelectFilter(typeof(Kaleido));
			} else if (Input.GetKeyDown(KeyCode.C)) {
				SelectFilter(typeof(SpaceOdyssey));
			} else if (Input.GetKeyDown(KeyCode.D)) {
				SelectFilter(typeof(Splashes));
			}

			if (currentFilterType == typeof(Kaleido)) {
				if (Input.GetKeyDown(KeyCode.KeypadPlus)) {
					SelectKaleidoCount(Mathf.Clamp(kaleidoCount + 1, 1, 16));
				} else if (Input.GetKeyDown(KeyCode.KeypadMinus)) {
					SelectKaleidoCount(Mathf.Clamp(kaleidoCount - 1, 1, 16));
				} else if (Input.GetKeyDown(KeyCode.Keypad1)) {
					SelectKaleidoCount(1);
				} else if (Input.GetKeyDown(KeyCode.Keypad2)) {
					SelectKaleidoCount(2);
				} else if (Input.GetKeyDown(KeyCode.Keypad3)) {
					SelectKaleidoCount(3);
				} else if (Input.GetKeyDown(KeyCode.Keypad4)) {
					SelectKaleidoCount(4);
				} else if (Input.GetKeyDown(KeyCode.Keypad5)) {
					SelectKaleidoCount(5);
				} else if (Input.GetKeyDown(KeyCode.Keypad6)) {
					SelectKaleidoCount(6);
				} else if (Input.GetKeyDown(KeyCode.Keypad7)) {
					SelectKaleidoCount(7);
				} else if (Input.GetKeyDown(KeyCode.Keypad8)) {
					SelectKaleidoCount(8);
				} else if (Input.GetKeyDown(KeyCode.Keypad9)) {
					SelectKaleidoCount(9);
				}
			}
		}

		void ResetFilter () {
			for (int i = 0; i < filterArray.Length; ++i) {
				Filter filter = filterArray[i];
				filter.enabled = false;
			}
		}

		void SelectFilter (Type type) {
			for (int i = 0; i < filterArray.Length; ++i) {
				Filter filter = filterArray[i];
				if (filter.GetType() == type) {
					filter.enabled = true;
				} else {
					filter.enabled = false;	
				}
			}
			currentFilterType = type;
		}

		void SelectKaleidoCount (int count) {
			kaleidoCount = count;
			UnityEngine.Shader.SetGlobalFloat("_KaleidoCount", (float)count);
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
