
// code is from :
// http://chromium.googlecode.com/svn/trunk/samples/audio/visualizer-live.html
// many thanks to Chris Wilson
// https://developers.google.com/web/updates/2012/09/Live-Web-Audio-Input-Enabled

define([], function()
{

var source;
var analyser;
var buffer;
var audioBuffer;

var analyserView1;


// getUserMedia({audio:true}, gotStream);

function error() {
    alert('Stream generation failed.');
  }

  function getUserMedia(dictionary, callback) {
      try {
          navigator.webkitGetUserMedia(dictionary, callback, error);
      } catch (e) {
          alert('webkitGetUserMedia threw exception :' + e);
          finishJSTest();
      }
  }

  function gotStream(stream) {
      s = stream;

      analyserView1 = new AnalyserView("view1");

      initAudio(stream);
      analyserView1.initByteBuffer();

      window.requestAnimationFrame(draw);
  }

  function initAudio(stream) {
      context = new webkitAudioContext();

      analyser = context.createAnalyser();
      analyser.fftSize = 2048;

      // Connect audio processing graph:
      // live-input -> analyser -> destination

      // Create an AudioNode from the stream.
      var mediaStreamSource = context.createMediaStreamSource(stream);
      mediaStreamSource.connect(analyser);
      analyser.connect(context.destination);
    }

    this.freqByteData = 0;

                freqByteData = new Uint8Array(analyser.frequencyBinCount);
                analyser.smoothingTimeConstant = 0.75;
                // analyser.smoothingTimeConstant = 0.1;
                analyser.getByteFrequencyData(freqByteData);


})
