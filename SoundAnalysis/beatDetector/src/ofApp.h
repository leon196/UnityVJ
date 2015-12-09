#pragma once

#include "ofMain.h"
#include "ofxBeat.h"
#include "ofxGui.h"
#include "ofxOsc.h"

#define HOST "localhost"
#define PORT 12345

class ofApp : public ofBaseApp{
    ofxBeat beat;

	public:
		void setup();
		void update();
		void draw();

		void keyPressed(int key);
		void keyReleased(int key);
		void mouseMoved(int x, int y );
		void mouseDragged(int x, int y, int button);
		void mousePressed(int x, int y, int button);
		void mouseReleased(int x, int y, int button);
		void mouseEntered(int x, int y);
		void mouseExited(int x, int y);
		void windowResized(int w, int h);
		void dragEvent(ofDragInfo dragInfo);
		void gotMessage(ofMessage msg);
        void setupArduino(const int & version);
        void arduinoLoop();
        void audioReceived(float*, int, int);
        ofArduino arduino;
        ofxOscSender sender;
        ofTrueTypeFont bisous, osc_message;
        bool isArduinoSet;
        float barWidth;

};
