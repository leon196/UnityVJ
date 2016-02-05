using UnityEngine;
using System;
using System.Collections;

public class Controller : MonoBehaviour {

	public Camera cameraEffect;
	// public TextMesh textDebug;
	
	Type currentFilterType = typeof(Fractal);
	int currentFilter = 0;
	Filter[] filterArray;
	bool autoNextMode = false;
	float autoNextLastTime = 0f;
	float autoNextDelay = 10f;
	
	Kaleido kaleido;	
	Kaleido3DManager kaleido3DManager;
	Wireframe wireframe;
	Planet planet;
	Splashes splashes;
	Fractal fractal;
	WarbandManager warband;
	GlitchyCam glitchyCam;

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
				currentFilterType = filter.GetType();
				break;
			}
		}

		kaleido = GameObject.FindObjectOfType<Kaleido>();
		kaleido3DManager = GameObject.FindObjectOfType<Kaleido3DManager>();
		wireframe = GameObject.FindObjectOfType<Wireframe>();
		planet = GameObject.FindObjectOfType<Planet>();
		splashes = GameObject.FindObjectOfType<Splashes>();
		fractal = GameObject.FindObjectOfType<Fractal>();
		warband = GameObject.FindObjectOfType<WarbandManager>();
		glitchyCam = GameObject.FindObjectOfType<GlitchyCam>();

		kaleido3DManager.transform.parent.gameObject.SetActive(false);
		planet.transform.parent.gameObject.SetActive(false);
		wireframe.transform.parent.gameObject.SetActive(false);
		// warband.transform.parent.gameObject.SetActive(false);
	}

	void Update () 
	{
		// Shader.SetGlobalVector("_Mouse", new Vector2(Input.mousePosition.x, Input.mousePosition.y));
		// textDebug.text = Input.mousePosition.x / Screen.width + "\n" + Input.mousePosition.y / Screen.height;

		if (Input.GetKeyDown(KeyCode.P)) {
			autoNextMode = !autoNextMode;
		}

		if (autoNextMode) {
			if (autoNextLastTime + autoNextDelay < Time.time) {
				autoNextLastTime = Time.time;
				NextFilter();
			}
		}

		if (Input.GetKeyDown(KeyCode.Space)) {
			NextFilter();
		}

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
		} else if (Input.GetKeyDown(KeyCode.F)) {
			SelectFilter(typeof(PlanetFilter));
		} else if (Input.GetKeyDown(KeyCode.G)) {
			SelectFilter(typeof(SpaceOdyssey));
		} else if (Input.GetKeyDown(KeyCode.H)) {
			SelectFilter(typeof(WarbandFilter));
		} else if (Input.GetKeyDown(KeyCode.I)) {
			SelectFilter(typeof(GlitchyCam));
		}

		// FRACTAL
		if (currentFilterType == typeof(Fractal)) {
			if (Input.GetKeyDown(KeyCode.Keypad0)) { fractal.ToggleFractalMode();
			} else if (Input.GetKey(KeyCode.KeypadPlus)) { fractal.UpZoom(); 
			} else if (Input.GetKey(KeyCode.KeypadMinus)) { fractal.DownZoom(); 
			} else if (Input.GetKeyDown(KeyCode.Keypad4)) { fractal.ToggleMoveX(); 
			} else if (Input.GetKeyDown(KeyCode.Keypad6)) { fractal.ToggleMoveY(); 
			} else if (Input.GetKeyDown(KeyCode.R)) { fractal.Reset(); }
		}

		// SPLASHES
		if (currentFilterType == typeof(Splashes)) {
			if (Input.GetKey(KeyCode.KeypadPlus)) { splashes.UpSpeed();
			} else if (Input.GetKey(KeyCode.KeypadMinus)) { splashes.DownSpeed(); 
			} else if (Input.GetKey(KeyCode.Keypad4)) {	splashes.DownDirectionColorRatio(); 
			} else if (Input.GetKey(KeyCode.Keypad6)) { splashes.UpDirectionColorRatio(); 
			} else if (Input.GetKeyDown(KeyCode.Keypad0)) {	splashes.SetSpeed(0f); 
			} else if (Input.GetKeyDown(KeyCode.Keypad1)) {	splashes.SetSpeed(0.33f); 
			} else if (Input.GetKeyDown(KeyCode.Keypad2)) {	splashes.SetSpeed(0.66f); 
			} else if (Input.GetKeyDown(KeyCode.Keypad3)) {	splashes.SetSpeed(0.99f); 
			} else if (Input.GetKeyDown(KeyCode.R)) {	splashes.Reset(); }
		}

		// KALEIDO 2D
		if (currentFilterType == typeof(Kaleido)) {
			if (Input.GetKey(KeyCode.KeypadPlus)) { kaleido.UpSpeed();
			} else if (Input.GetKey(KeyCode.KeypadMinus)) { kaleido.DownSpeed();
			} else if (Input.GetKeyDown(KeyCode.Keypad1)) {	kaleido.SetKaleidoCount(1); 
			} else if (Input.GetKeyDown(KeyCode.Keypad2)) {	kaleido.SetKaleidoCount(2); 
			} else if (Input.GetKeyDown(KeyCode.Keypad3)) {	kaleido.SetKaleidoCount(3); 
			} else if (Input.GetKeyDown(KeyCode.Keypad4)) {	kaleido.SetKaleidoCount(4); 
			} else if (Input.GetKeyDown(KeyCode.Keypad5)) {	kaleido.SetKaleidoCount(5); 
			} else if (Input.GetKeyDown(KeyCode.Keypad6)) {	kaleido.SetKaleidoCount(6); 
			} else if (Input.GetKeyDown(KeyCode.Keypad7)) {	kaleido.SetKaleidoCount(7); 
			} else if (Input.GetKeyDown(KeyCode.Keypad8)) {	kaleido.SetKaleidoCount(8); 
			} else if (Input.GetKeyDown(KeyCode.Keypad9)) {	kaleido.SetKaleidoCount(9); 
			} else if (Input.GetKeyDown(KeyCode.R)) { kaleido.Reset(); }
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
			} else if (Input.GetKeyDown (KeyCode.Keypad1)) { kaleido3DManager.complexity = 3;
			} else if (Input.GetKeyDown (KeyCode.Keypad2)) { kaleido3DManager.complexity = 8;
			} else if (Input.GetKeyDown (KeyCode.Keypad3)) { kaleido3DManager.complexity = 10;
			} else if (Input.GetKeyDown (KeyCode.Keypad4)) { kaleido3DManager.complexity = 12;
			} else if (Input.GetKeyDown (KeyCode.Keypad5)) { kaleido3DManager.complexity = 15;
			} else if (Input.GetKeyDown(KeyCode.R)) { kaleido3DManager.Reset(); }

		} else if (kaleido3DManager.transform.parent.gameObject.activeInHierarchy) {
			kaleido3DManager.transform.parent.gameObject.SetActive(false);
		}

		// WIREFRAME
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

		// PLANET
		if (currentFilterType == typeof(PlanetFilter)) {
			if (planet.transform.parent.gameObject.activeInHierarchy == false) {
				planet.transform.parent.gameObject.SetActive(true);
			}
			if (Input.GetKeyDown(KeyCode.KeypadPlus)) { planet.IncrementUVScale(); 
			} else if (Input.GetKeyDown(KeyCode.KeypadMinus)) { planet.DecrementUVScale();
			} else if (Input.GetKeyDown(KeyCode.R)) { planet.Reset(); }

		} else if (planet.transform.parent.gameObject.activeInHierarchy) {
			planet.transform.parent.gameObject.SetActive(false);
		}

		// WARBAND
		if (currentFilterType == typeof(WarbandFilter)) {
			if (warband.transform.parent.gameObject.activeInHierarchy == false) {
				warband.transform.parent.gameObject.SetActive(true);
			}
			if (Input.GetKeyDown(KeyCode.Keypad0)) { warband.RumbleCamera(); }

		} else if (warband.transform.parent.gameObject.activeInHierarchy) {
			warband.transform.parent.gameObject.SetActive(false);
		}

		// GlitchyCam
		if (currentFilterType == typeof(GlitchyCam)) {
			if (Input.GetKeyDown (KeyCode.KeypadPlus)) { glitchyCam.intensity += 0.2f; 
			} else if (Input.GetKeyDown (KeyCode.KeypadMinus)) { glitchyCam.intensity -= 0.2f; 
			} else if (Input.GetKeyDown(KeyCode.R)) { glitchyCam.Reset(); }
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

	void NextFilter () {
		currentFilter = (currentFilter + 1) % filterArray.Length;
		for (int i = 0; i < filterArray.Length; ++i) {
			Filter filter = filterArray[i];
			if (i != currentFilter) {
				filter.enabled = false;
			} else {
				filter.enabled = true;
				currentFilterType = filter.GetType();
			}
		}
	}
}
