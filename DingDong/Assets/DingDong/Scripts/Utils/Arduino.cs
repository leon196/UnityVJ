using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.IO.Ports;
using System.Linq;
using System.Globalization;
using UnityEngine;

public class Arduino 
{
	// Stack overflow
	private SerialPort stream;
	private StreamReader IN;
	
	// Raw data
	private String[] input;

	// 
	public bool detected = false;
	public bool enabled = true;
	public bool ready = false;
	
	//
	private bool[] buttons;
	private bool[] switches;

	// Singleton
	private static Arduino _singleton = null;
	public static Arduino Instance {
		get {
			if (_singleton == null) 
			{
				_singleton = new Arduino();
			}
			return _singleton;
		}
	}

	public Arduino ()
	{
		foreach (String portName in SerialPort.GetPortNames()) {
			stream = new SerialPort(portName, 9600);
			detected = true;
			Debug.Log("Detected Arduino at : " + portName);
			break;
		}
		if (detected) {
			stream.Open();
			IN = new StreamReader(stream.BaseStream);
			IN.ReadLine();

			buttons = new bool[] { false, false, false };
			switches = new bool[] { false, false, false };
			
			input = IN.ReadLine().Split(',');
			ready = true;
		}
	}

	public bool isEnabled {
		get { return detected && enabled && ready; }
	}

	public void Update()
	{
		// Read arduino serial
		input = IN.ReadLine().Split(',');
	}

	// Parse string input "3 buttons, 3 switches, 2 sliders, 3 spiners"

	// [1, 2, 3]
	public bool Button (int number)
	{
		return int.Parse(input[number-1]) == 1;
	}

	public bool ButtonPressed (int number)
	{
		if (Button(number)) 
		{
			if (buttons[number - 1] == false) 
			{
				buttons[number - 1] = true;
				return true;
			} 
		} else {
			buttons[number - 1] = false;
		}
		return false;
	}

	// [1, 2, 3]
	public bool Switch (int number)
	{
		return int.Parse(input[3 + number-1]) == 1;
	}
	public bool SwitchSwitched (int number)
	{
		if (Switch(number) != switches[number - 1]) 
		{
			switches[number - 1] = Switch(number);
			return true;
		}
		return false;
	}

	// [1, 2]
	public float Slider (int number)
	{
		return int.Parse(input[6 + number-1]) / 100f;
	}

	// 
	public float SliderWithDetails (int number, float details)
	{
		return Mathf.Floor(details * int.Parse(input[6 + number-1]) / 100f) / details;
	}

	// [1, 2, 3]
	public float Spiner (int number)
	{
		return int.Parse(input[8 + number-1]) / 100f;
	}

	//
	public float SpinerWithDetails (int number, float details)
	{
		return Mathf.Floor(details * Spiner(number)) / details;
	}

}