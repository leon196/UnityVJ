
// code is from :
// http://chromium.googlecode.com/svn/trunk/samples/audio/visualizer-live.html
// many thanks to Chris Wilson
// https://developers.google.com/web/updates/2012/09/Live-Web-Audio-Input-Enabled

define(['../lib/pixi'], function(PIXI)
{
  var UserMedia = {}

  UserMedia.isReady = false
  UserMedia.analyser
  UserMedia.frequenceByteData
  UserMedia.frequenceTexture

  UserMedia.init = function()
  {
    try
    {
      navigator.webkitGetUserMedia({audio:true}, UserMedia.gotStream, function(){alert('Stream generation failed.')})
    }
    catch (e)
    {
      //alert('webkitGetUserMedia threw exception :' + e)
    }
  }

  UserMedia.gotStream = function(stream)
  {
    context = new AudioContext()

    UserMedia.analyser = context.createAnalyser()
    UserMedia.analyser.fftSize = 256

    // Connect audio processing graph:
    // live-input -> analyser -> destination

    // Create an AudioNode from the stream.
    var mediaStreamSource = context.createMediaStreamSource(stream)
    mediaStreamSource.connect(UserMedia.analyser)
    UserMedia.analyser.connect(context.destination)

    var volume = context.createGain();
    mediaStreamSource.connect(volume);
    volume.gain.value = -1;
    volume.connect(context.destination);

    UserMedia.frequenceByteData = new Uint8Array(UserMedia.analyser.frequencyBinCount)
    UserMedia.analyser.smoothingTimeConstant = 0.75

    UserMedia.isReady = true
  }

  UserMedia.update = function ()
  {
    if (UserMedia.isReady)
    {
      UserMedia.analyser.getByteFrequencyData(UserMedia.frequenceByteData)
      var v = 0
      for (var i = 0; i < UserMedia.analyser.frequencyBinCount; ++i)
      {
        v += UserMedia.frequenceByteData[i]
      }
      UserMedia.frequenceTotal = v / UserMedia.analyser.frequencyBinCount / 255
    }
  }

  return UserMedia
})
