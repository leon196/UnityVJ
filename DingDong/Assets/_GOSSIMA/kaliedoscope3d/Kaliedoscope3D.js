#pragma strict

var material : Material;

// kaliedoscope user variable
var screenSize : Vector2 = Vector2(17,10);
var kaliedoscopeBlades : int = 5;
var complexity : int = 10;
var speed : float = 10.0;

private var container : GameObject;
private var cubes : GameObject[] = new GameObject[2];
private var holders : GameObject[];

function Awake () {
	 cubes = new GameObject[complexity];
	 container = new GameObject();
	 createKaliedoscope();
}

function Update () {
	// rotate kaliedoscope
	for (hold in holders){	
		hold.transform.Rotate(Vector3.right * Time.deltaTime * speed);	
	}
}

function ResetKaliedoscope(){ // delete existing kaliedoscope and regenerate a new one
	for (holder in holders){
		if (holder != container)
			Destroy(holder);			
	}
	for (cube in cubes)
		Destroy(cube);		
	cubes = new GameObject[complexity];
	createKaliedoscope();
}

function Realign(){ // match uv to remap video 
	for (holder in holders){		
		for (var cube : Transform in holder.transform) {
			var mesh: Mesh = cube.GetComponent.<MeshFilter>().mesh;
			var vertices: Vector3[] = mesh.vertices;
			var uvs: Vector2[] = new Vector2[vertices.Length];
			for (var i: int = 0; i < uvs.Length; i++) {
				var pos = cube.transform.TransformPoint(vertices[i]);
				uvs[i] = new Vector2((pos.x/screenSize.x)+0.5, (pos.z/screenSize.y)+0.5);
			}
			cube.gameObject.GetComponent.<MeshFilter>().mesh.uv = uvs;			
		}
	}	
}

function createKaliedoscope(){ // generateb new kaliedoscope
	holders = new GameObject[kaliedoscopeBlades];
	holders[0] = container;
	for (cube in cubes){ // generate random cubes in the container
		cube = GameObject.CreatePrimitive(PrimitiveType.Cube);
		var position: Vector3 = Vector3(Random.Range(0, screenSize.x/2), 0, Random.Range(0, screenSize.y/2));
		var scale: Vector3 = Vector3(Random.Range(1, 10.0),Random.Range(0, 10.0), Random.Range(0, 10.0));
		scale /= complexity/5.0;
		var rotation: Vector3 = Vector3(Random.Range(-180,180),Random.Range(-180,180), Random.Range(-180,180));
		cube.transform.position = position;
		cube.transform.localScale = scale;
		cube.transform.localEulerAngles = rotation;		
		cube.GetComponent.<Renderer>().sharedMaterial = material;
		cube.transform.parent = container.transform;
	}
	container.SetActive(true);
	for (var i = 0; i < kaliedoscopeBlades; i++) { // duplicate and rotate it 
		holders[i] = Instantiate(container, Vector3.zero, Quaternion.identity);
		holders[i].transform.localEulerAngles = Vector3 (0,360*i/kaliedoscopeBlades,0);
	}
	container.SetActive(false);	
}