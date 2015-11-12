using UnityEngine;

/*
OSC RECEIVER C#
A modified version of this plugin - https://github.com/heaversm/unity-osc-receiver
*/

[RequireComponent(typeof(Osc))]
[RequireComponent(typeof(UDPPacketIO))]
public class OSCReceiverC : MonoBehaviour 
{
  [SerializeField] private string     remoteIP        = "127.0.0.1";
  [SerializeField] private int        listenerPort    = 8000;
  [SerializeField] private int        senderPort      = 9000;
  private Osc                         handler;

  public static int                   OSCcount        = 32;
  public static float[]               OSCvalues       = new float[OSCcount];

  Texture2D texture2D;
  Color[] colors;
  float fftTotal;

  void Awake ()
  {
    texture2D = new Texture2D(OSCcount, 1);
    texture2D.filterMode = FilterMode.Point;
    colors = new Color[OSCcount];
    for (int i = 0; i < OSCcount; i++) {
      colors[i] = new Color(1f, 1f, 1f, 1f);
    }
    texture2D.SetPixels(colors);
    Shader.SetGlobalTexture("_TextureFFT", texture2D);
    fftTotal = 0f;
  }

  void Start () {
    UDPPacketIO udp = GetComponent<UDPPacketIO>();
    udp.init(remoteIP, senderPort, listenerPort);
    handler = GetComponent<Osc>();
    handler.init(udp);
    handler.SetAllMessageHandler(MessageHandler);
  }

  // called every time Unity receives a message
  public void MessageHandler(OscMessage message) {
    // string msgString = Osc.OscMessageToString(message);
    for (int i = 0; i < OSCcount; i++) {
      OSCvalues[i] = float.Parse(message.Values[i].ToString());
    }
  }


  void Update ()
  {
    float fft = 0f;
    float fftGlobal = 0f;
    for (int i = 0; i < OSCcount; i++) {
      fft = OSCvalues[i];
      colors[i] = new Color(fft, fft, fft, fft);
      fftGlobal += fft;
    }
    fftGlobal /= (float)OSCcount;
    fftTotal += fftGlobal;
    Shader.SetGlobalFloat("_GlobalFFT", fftGlobal);
    Shader.SetGlobalFloat("_GlobalFFTTotal", fftTotal);
    texture2D.SetPixels(colors);
    texture2D.Apply(false);
  }
}
