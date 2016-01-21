using UnityEngine;
using System;
using System.Collections;

public class Controller : MonoBehaviour {

	public Camera cameraEffect;
	public TextMesh textDebug;
	
	Type currentFilterType = typeof(Fractal);
	int currentFilter = 0;
	Filter[] filterArray;
	
	// Kaleido 2D
	int kaleidoCount = 1;

	// Kaleido 3D
	Kaleido3DManager kaleido3DManager;
	Wireframe wireframe;

	void Start () 
	{
#if !UNITY_EDITOR
		Cursor.visible = false;
#endif

		// Filters attached on camera
		filterArray = cameraEffect.GetComponents<Filter>();
		for (int i = 0; i < filterArray.Length; ++i) {
			Filter filter = filterArray[i];
			if (filter.enabled) {
				currentFilter = i;
				break;
			}
		}

		// Kaleido 2D
		SelectKaleidoCount(1);

		// Kaleido 3D
		kaleido3DManager = GameObject.FindObjectOfType<Kaleido3DManager>();
		kaleido3DManager.transform.parent.gameObject.SetActive(false);
		
		// Wireframe
		wireframe = GameObject.FindObjectOfType<Wireframe>();
		wireframe.transform.parent.gameObject.SetActive(false);
	}

	void Update () 
	{
		Shader.SetGlobalVector("_Mouse", new Vector2(Input.mousePosition.x, Input.mousePosition.y));
		textDebug.text = Input.mousePosition.x / Screen.width + "\n" + Input.mousePosition.y / Screen.height;

		// Switch effect
		if (Input.GetKeyDown(KeyCode.A)) {
			SelectFilter(typeof(Fractal));
		} else if (Input.GetKeyDown(KeyCode.B)) {
			SelectFilter(typeof(Kaleido));
		} else if (Input.GetKeyDown(KeyCode.C)) {
			SelectFilter(typeof(Kaleido3DFilter));
		} else if (Input.GetKeyDown(KeyCode.D)) {
			SelectFilter(typeof(Splashes));
		} else if (Input.GetKeyDown(KeyCode.E)) {
			SelectFilter(typeof(WireframeFilter));
		}

		// KALEIDO 2D
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

		// KALEIDO 3D
		if (currentFilterType == typeof(Kaleido3DFilter)) {
			if (kaleido3DManager.transform.parent.gameObject.activeInHierarchy == false) {
				kaleido3DManager.transform.parent.gameObject.SetActive(true);
			}
			if (Input.GetKeyDown (KeyCode.KeypadPlus)){
				kaleido3DManager.kaliedoscopeBlades++;
				kaleido3DManager.ResetKaliedoscope();
			} else if (Input.GetKeyDown (KeyCode.KeypadMinus)){
				if (kaleido3DManager.kaliedoscopeBlades > 2){
					kaleido3DManager.kaliedoscopeBlades--;
					kaleido3DManager.ResetKaliedoscope();
				}
			} else if (Input.GetKeyDown (KeyCode.Keypad1)) {
				kaleido3DManager.complexity = 3;
			} else if (Input.GetKeyDown(KeyCode.Keypad2)) {
				kaleido3DManager.complexity = 8;
			} else if (Input.GetKeyDown (KeyCode.Keypad3)) {
				kaleido3DManager.complexity = 10;
			} else if (Input.GetKeyDown (KeyCode.Keypad4)) {
				kaleido3DManager.complexity = 12;
			} else if (Input.GetKeyDown (KeyCode.Keypad5)){
				kaleido3DManager.complexity = 15;
			}
		} else if (kaleido3DManager.transform.parent.gameObject.activeInHierarchy) {
			kaleido3DManager.transform.parent.gameObject.SetActive(false);
		}

		// Wireframe
		if (currentFilterType == typeof(WireframeFilter)) {
			if (wireframe.transform.parent.gameObject.activeInHierarchy == false) {
				wireframe.transform.parent.gameObject.SetActive(true);
			}
			if (Input.GetKeyDown (KeyCode.KeypadPlus)){
				if (wireframe.tesselate > 6)
					wireframe.tesselate -= 4;  
				wireframe.material.SetFloat("_EdgeLength", wireframe.tesselate);
			}
				
			if (Input.GetKeyDown (KeyCode.KeypadMinus)){
				wireframe.tesselate += 4;  
				wireframe.material.SetFloat("_EdgeLength", wireframe.tesselate);
			}
		} else if (wireframe.transform.parent.gameObject.activeInHierarchy) {
			wireframe.transform.parent.gameObject.SetActive(false);
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
