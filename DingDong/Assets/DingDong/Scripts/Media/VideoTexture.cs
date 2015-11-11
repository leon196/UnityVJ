using UnityEngine;
using System.Collections;

public class VideoTexture : MonoBehaviour
{
	public string videoName = "Back To The Futur.ogg";
	public Material videoMaterial;

	void Start ()
	{
		StartCoroutine(LoadMovieTexture());
	} 

	IEnumerator LoadMovieTexture ()
	{
		string URL = "file://" + Application.dataPath + "/StreamingAssets/" + videoName;

		WWW www = new WWW(URL);

		MovieTexture movieTexture = www.movie as MovieTexture;
        movieTexture.loop = true;

        while (!movieTexture.isReadyToPlay) {
            yield return 0;
        }

        videoMaterial.mainTexture = movieTexture;
		Shader.SetGlobalTexture("_VideoTexture", movieTexture);
        movieTexture.Play();
	}
}
