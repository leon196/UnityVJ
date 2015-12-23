using UnityEngine;
using System.Collections;

public class OSCGreg : MonoBehaviour {

	public string RemoteIP = "localhost"; //127.0.0.1 signifies a local host (if testing locally
	public int SendToPort = 9000; //the port you will be sending from
	public int ListenerPort = 12345; //the port you will be listening on
	public Transform controller;
	public string gameReceiver = "Cube"; //the tag of the object on stage that you want to manipulate
	private Osc handler;
	
	//VARIABLES YOU WANT TO BE ANIMATED
	private int yRot = 0; //the rotation around the y axis
	
	void Start () {
		//Initializes on start up to listen for messages
		//make sure this game object has both UDPPackIO and OSC script attached
		UDPPacketIO udp = GetComponent<UDPPacketIO>();
		udp.init(RemoteIP, SendToPort, ListenerPort);
		handler = GetComponent<Osc>();
		handler.init(udp);
		handler.SetAllMessageHandler(AllMessageHandler);
	}
	
	void Update () {
		controller.Rotate(0f, yRot, 0f);
	}
	
	//These functions are called when messages are received
	//Access values via: oscMessage.Values[0], oscMessage.Values[1], etc
	public void AllMessageHandler (OscMessage oscMessage) {
		//string msgString = Osc.OscMessageToString(oscMessage); //the message and value combined
		string msgAddress = oscMessage.Address; //the message parameters
		//float msgValue = (float)oscMessage.Values[0]; //the message value
		//FUNCTIONS YOU WANT CALLED WHEN A SPECIFIC MESSAGE IS RECEIVED
		switch (msgAddress){
			case "/kick": {
				Debug.Log("KICK");
				break;
			}
		}
	}
}
