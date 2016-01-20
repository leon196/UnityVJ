// Assigns a webcam texture to current shared material and play webcam.
// put this script on an object with webcam material (unlit)

var webcamText: WebCamTexture = WebCamTexture();

function Start () {

	
	DontDestroyOnLoad (transform.gameObject);	
	var renderer: Renderer = GetComponent.<Renderer>();
	
	if (renderer.sharedMaterial.mainTexture == null){
		webcamText = WebCamTexture();
		renderer.sharedMaterial.mainTexture = webcamText;
		webcamText.Play();
		Debug.Log ("start webcam");
	}
}

function OnLevelWasLoaded (level : int) {
	webcamText.Play();
}