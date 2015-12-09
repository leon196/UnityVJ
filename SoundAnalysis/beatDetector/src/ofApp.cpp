#include "ofApp.h"

//--------------------------------------------------------------
void ofApp::setupArduino(const int & version) {
    ofRemoveListener(arduino.EInitialized, this, &ofApp::setupArduino);
    arduino.sendDigitalPinMode(11, ARD_OUTPUT);
    isArduinoSet = true;
}
//--------------------------------------------------------------
void ofApp::setup(){
    //OSC open to HOST:PORT
    
    sender.setup(HOST, PORT);
    
    arduino.connect("/dev/tty.usbmodem1421", 57600);
    ofAddListener(arduino.EInitialized, this, &ofApp::setupArduino);
    
    ofSoundStreamSetup(0, 1, this, 44100, beat.getBufferSize(), 4);
    ofSetVerticalSync(true);
    ofEnableSmoothing();

    barWidth = ofGetWidth() / 32;
    isArduinoSet = false;
    
    bisous.load("bisous.ttf", 20, true, true);
    osc_message.load("bisous.ttf", 10, true, true);
}

//--------------------------------------------------------------
void ofApp::update(){
    beat.update(ofGetElapsedTimeMillis());
    
    float kickValue = beat.kick();
    if (kickValue == 1) {
        ofxOscMessage m;
        m.setAddress("/kick");
        m.addIntArg(1);
        sender.sendMessage(m);
    } else {
        ofxOscMessage m;
        m.setAddress("/kick");
        m.addIntArg(0);
        sender.sendMessage(m);
    }
    
    ofApp::arduinoLoop();
}

//--------------------------------------------------------------
void ofApp::arduinoLoop(){
    if (isArduinoSet){
        if (beat.kick() == 1) {
            arduino.sendDigital(11, ARD_HIGH);

        } else {
            arduino.sendDigital(11, ARD_LOW);
        }
    }
    arduino.update();
}

//--------------------------------------------------------------
void ofApp::draw(){
    string message = "";
    ofBackground(0);
    ofSetColor(179, 71, 255);
    
    for (int i = 0; i < 32; i++) {
        float selectedBand = beat.getBand(i);
        ofFill();
        ofRect(i * barWidth, ofGetHeight(), barWidth, -(selectedBand*100));
        ofNoFill();
    }

    if (!isArduinoSet){
        message = "Waiting for arduino...";
    } else {
        message = "nanoKiss";
    }
    ofRectangle rect = bisous.getStringBoundingBox(message, 0,0);
    bisous.drawString(message, ofGetWidth()/2 - rect.width/2, 50);
    
    ofSetColor(255, 0, 0);
    if (beat.kick() == 1) {
        message = "OSC send ...";
        ofRectangle rect = osc_message.getStringBoundingBox(message, 0,0);
        osc_message.drawString(message, ofGetWidth()/2 - rect.width/2, 80);
    }
}

//--------------------------------------------------------------
void ofApp::audioReceived(float* input, int bufferSize, int nChannels) {
    beat.audioReceived(input, bufferSize, nChannels);
}

//--------------------------------------------------------------
void ofApp::keyPressed(int key){
}

//--------------------------------------------------------------
void ofApp::keyReleased(int key){

}

//--------------------------------------------------------------
void ofApp::mouseMoved(int x, int y ){

}

//--------------------------------------------------------------
void ofApp::mouseDragged(int x, int y, int button){

}

//--------------------------------------------------------------
void ofApp::mousePressed(int x, int y, int button){

}

//--------------------------------------------------------------
void ofApp::mouseReleased(int x, int y, int button){

}

//--------------------------------------------------------------
void ofApp::mouseEntered(int x, int y){

}

//--------------------------------------------------------------
void ofApp::mouseExited(int x, int y){

}

//--------------------------------------------------------------
void ofApp::windowResized(int w, int h){
        barWidth = w / 32;
}

//--------------------------------------------------------------
void ofApp::gotMessage(ofMessage msg){

}

//--------------------------------------------------------------
void ofApp::dragEvent(ofDragInfo dragInfo){ 

}
