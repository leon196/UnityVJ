#include "ofApp.h"

//--------------------------------------------------------------
void ofApp::setup(){
    ofSetVerticalSync(true);
    ofEnableSmoothing();
    ofSoundStreamSetup(0, 1, this, 44100, beat.getBufferSize(), 4);
    
    //setup UI elements
    gui.setup();
    
    gui.add(kick.setup("kick", ofToString(0)));
    gui.add(hithat.setup("hithat", ofToString(0)));
    gui.add(snare.setup("snare", ofToString(0)));
    
    barWidth = ofGetWidth() / 32;
    circleSeparation = ofGetWidth() / 4;
}

//--------------------------------------------------------------
void ofApp::update(){
    beat.update(ofGetElapsedTimeMillis());
}

//--------------------------------------------------------------
void ofApp::draw(){
    ofBackground(0);

    float kickValue = beat.kick();
    float snareValue = beat.snare();
    float hithatValue = beat.hihat();
    
    for (int i = 0; i < 32; i++) {
        float selectedBand = beat.getBand(i);
        ofSetColor(179, 71, 255); // Set the drawing color to white
        ofFill();
        ofRect(i * barWidth, ofGetHeight(), barWidth, -(selectedBand*100));
        ofNoFill();
    }
    
    kick = ofToString(kickValue);
    snare = ofToString(snareValue);
    hithat = ofToString(hithatValue);
    
    
   
    if (kickValue == 1) {
        ofSetColor(255,0,0);
        ofFill();
        ofCircle(circleSeparation, ofGetHeight()/2, 50);
        ofNoFill();
    }
    if (snareValue == 1) {
        ofSetColor(255, 133, 44);
        ofFill();
        ofCircle(circleSeparation*2, ofGetHeight()/2, 50);
        ofNoFill();
    }
    if (hithatValue == 1) {
        ofSetColor(255, 239, 0);
        ofFill();
        ofCircle(circleSeparation*3, ofGetHeight()/2, 50);
        ofNoFill();
    }

    
    gui.draw();
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

}

//--------------------------------------------------------------
void ofApp::gotMessage(ofMessage msg){

}

//--------------------------------------------------------------
void ofApp::dragEvent(ofDragInfo dragInfo){ 

}
