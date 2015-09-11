
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
      alert('webkitGetUserMedia threw exception :' + e)
    }
  }
  // public method for encoding an Uint8Array to base64
function encode (input) {
    var keyStr = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
    var output = "";
    var chr1, chr2, chr3, enc1, enc2, enc3, enc4;
    var i = 0;

    while (i < input.length) {
        chr1 = input[i++];
        chr2 = i < input.length ? input[i++] : Number.NaN; // Not sure if the index
        chr3 = i < input.length ? input[i++] : Number.NaN; // checks are needed here

        enc1 = chr1 >> 2;
        enc2 = ((chr1 & 3) << 4) | (chr2 >> 4);
        enc3 = ((chr2 & 15) << 2) | (chr3 >> 6);
        enc4 = chr3 & 63;

        if (isNaN(chr2)) {
            enc3 = enc4 = 64;
        } else if (isNaN(chr3)) {
            enc4 = 64;
        }
        output += keyStr.charAt(enc1) + keyStr.charAt(enc2) +
                  keyStr.charAt(enc3) + keyStr.charAt(enc4);
    }
    return output;
}

  UserMedia.gotStream = function(stream)
  {
    context = new AudioContext()

    UserMedia.analyser = context.createAnalyser()
    UserMedia.analyser.fftSize = 2048

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
      UserMedia.frequenceTotal = v / UserMedia.analyser.frequencyBinCount / 100
    }
  }

  return UserMedia
})
