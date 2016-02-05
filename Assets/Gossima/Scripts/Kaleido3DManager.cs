using UnityEngine;
using System.Collections;

public class Kaleido3DManager : MonoBehaviour 
{
	public Material material;

	// kaliedoscope user variable
	public Vector2 screenSize = new Vector2(17,10);
	public int kaliedoscopeBlades = 5;
	public int complexity = 10;
	public float speed = 10f;

	private GameObject container;
	private GameObject[] cubes = new GameObject[2];
	private GameObject[] holders;

	void Awake () 
	{
		cubes = new GameObject[complexity];
		container = new GameObject();
		container.transform.parent = this.transform;
		container.transform.localPosition = Vector3.zero;
		createKaliedoscope();
	}

	void Update  () 
	{
		// rotate kaliedoscope
		foreach (GameObject hold in holders) {	
			hold.transform.Rotate(Vector3.right * Time.deltaTime * speed);	
		}
	}

	// delete existing kaliedoscope and regenerate a new one
	public void ResetKaliedoscope ()
	{ 
		foreach (GameObject hold in holders){
			if (hold != container)
				Destroy(hold);			
		}
		foreach (GameObject cube in cubes)
			Destroy(cube);		
		cubes = new GameObject[complexity];
		createKaliedoscope();
	}

	public void Reset (){ // match uv to remap video 
		foreach (GameObject holder in holders){		
			foreach (Transform cube in holder.transform) {
				Mesh mesh = cube.GetComponent<MeshFilter>().mesh;
				Vector3[] vertices = mesh.vertices;
				Vector2[] uvs = new Vector2[vertices.Length];
				for (int i = 0; i < uvs.Length; i++) {
					Vector3 pos = cube.transform.TransformPoint(vertices[i]);
					uvs[i] = new Vector2((pos.x/screenSize.x) + 0.5f, (pos.z/screenSize.y) + 0.5f);
				}
				cube.gameObject.GetComponent<MeshFilter>().mesh.uv = uvs;			
			}
		}	
	}

	void createKaliedoscope () { // generateb new kaliedoscope
		holders = new GameObject[kaliedoscopeBlades];
		holders[0] = container;
		for (int i = 0; i < cubes.Length; ++i){ // generate random cubes in the container
			GameObject cube = cubes[i];
			cube = GameObject.CreatePrimitive(PrimitiveType.Cube);
			Vector3 position = new Vector3(Random.Range(0f, screenSize.x/2f), 0f, Random.Range(0f, screenSize.y/2f));
			Vector3 scale = new Vector3(Random.Range(1f, 10f),Random.Range(0f, 10f), Random.Range(0f, 10f));
			scale /= complexity / 5.0f;
			Vector3 rotation = new Vector3(Random.Range(-180f,180f),Random.Range(-180f,180f), Random.Range(-180f,180f));
			cube.transform.parent = container.transform;
			cube.transform.localPosition = position;
			cube.transform.localScale = scale;
			cube.transform.localEulerAngles = rotation;		
			cube.GetComponent<Renderer>().sharedMaterial = material;
		}
		container.SetActive(true);
		for (int i = 0; i < kaliedoscopeBlades; i++) { // duplicate and rotate it 
			holders[i] = Instantiate(container, Vector3.zero, Quaternion.identity) as GameObject;
			holders[i].transform.localEulerAngles = new Vector3(0f, 360f * i / kaliedoscopeBlades, 0f);
			holders[i].transform.parent = this.transform;
			holders[i].transform.localPosition = Vector3.zero;
		}
		container.SetActive(false);	
	}
}