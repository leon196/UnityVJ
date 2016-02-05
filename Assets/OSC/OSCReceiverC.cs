using UnityEngine;

/* 
	OSC RECEIVER C#
	A modified version of this plugin - https://github.com/heaversm/unity-osc-receiver
*/

[RequireComponent(typeof(Osc))]
[RequireComponent(typeof(UDPPacketIO))]
public class OSCReceiverC : MonoBehaviour {
    #region Variables
    [SerializeField] private string     remoteIP        = "127.0.0.1";
    [SerializeField] private int        listenerPort    = 8000;
    [SerializeField] private int        senderPort      = 9000;
    private Osc                         handler;

	colorCorrect colorCorrect;
	public GameObject cam; 


    public static int                   OSCcount        = 8;
    public static float[]               OSCvalues       = new float[OSCcount];

	  Texture2D texture2D;
	  Texture2D texture2DPoint;
	  Color[] colors;
	  float fftTotal;
    #endregion

	  void Awake ()
	  {
	    texture2D = new Texture2D(OSCcount, 1);
	    texture2DPoint = new Texture2D(OSCcount, 1);
	    texture2DPoint.filterMode = FilterMode.Point;
	    colors = new Color[OSCcount];
	    for (int i = 0; i < OSCcount; i++) {
	      colors[i] = new Color(1f, 1f, 1f, 1f);
	    }
	    texture2D.SetPixels(colors);
	    texture2DPoint.SetPixels(colors);
	    Shader.SetGlobalTexture("_TextureFFT", texture2D);
	    Shader.SetGlobalTexture("_TextureFFTPoint", texture2DPoint);
	    fftTotal = 0f;
	  }

    #region Monobehaviour Methods
    void Start () {
        UDPPacketIO udp = GetComponent<UDPPacketIO>();
        udp.init(remoteIP, senderPort, listenerPort);
        handler = GetComponent<Osc>();
        handler.init(udp);
        handler.SetAllMessageHandler(MessageHandler);
		handler = GetComponent<Osc>();

		colorCorrect = cam.GetComponent<colorCorrect>();
    }
    #endregion

    #region Methods
    // called every time Unity receives a message
    public void MessageHandler(OscMessage message) {
        // string msgString = Osc.OscMessageToString(message);
        //MainDebug.WriteLine(msgString);     // writing out the message to see if everything works correctly
		//Debug.Log (msgString);

		// clean debug message

		string debugLine = "received for adress : ";
		debugLine += message.Address + " with values : ";
		int j = 0;
		foreach (object o in message.Values) {
			debugLine += o.ToString () + ", ";
			OSCvalues [j] = float.Parse (message.Values [j].ToString ());
			j++;
		}
		Debug.Log (debugLine);



		if (message.Address == "/gain"){
			float gain = float.Parse(message.Values[0].ToString());
			colorCorrect.gain = Mathf.Pow (10,(gain*2));
		}

		if (message.Address == "/gamma"){
			float gamma = float.Parse(message.Values[0].ToString());
			colorCorrect.gamma = 1/(gamma*2);
		}

		if (message.Address == "/black"){
			colorCorrect.black = float.Parse(message.Values[0].ToString());
		}


    }
    #endregion
    


  void Update ()
  {
    float fft = 0f;
    float fftGlobal = 0f;
    for (int i = 0; i < OSCcount; i++) {
      fft = OSCvalues[i];
      fft = Mathf.Clamp(fft, 0f, 1f);
      colors[i] = new Color(fft, fft, fft, fft);
      fftGlobal += fft;
    }
    fftGlobal /= (float)OSCcount;
    fftTotal += fftGlobal;
    Shader.SetGlobalFloat("_GlobalFFT", fftGlobal);
    Shader.SetGlobalFloat("_GlobalFFTTotal", fftTotal);
    texture2D.SetPixels(colors);
    texture2D.Apply(false);
    texture2DPoint.SetPixels(colors);
    texture2DPoint.Apply(false);
  }
}