
define(['../lib/pixi', '../media/video', '../base/global', '../control/keyboard', '../media/usermedia'],
function(PIXI, Video, Global, Keyboard, UserMedia)
{
  var Render = {}

  // PIXI WebGL renderer
  Render.renderer = PIXI.autoDetectRenderer(window.innerWidth, window.innerHeight, {view:document.getElementById('container')})

  // Layers
  Render.layerDraw = new PIXI.Container()
  Render.layerVideo = new PIXI.Container()
  Render.layerBuffer1 = new PIXI.Container()
  Render.layerBuffer2 = new PIXI.Container()

  // Medias
  Render.video = new Video('videos/vh1.ogv')
  Render.spriteVideo = new PIXI.Sprite(PIXI.Texture.fromVideo(Render.video.DOM, PIXI.SCALE_MODES.NEAREST))
  Render.spriteVideo.width = window.innerWidth
  Render.spriteVideo.height = window.innerHeight

  // Render Textures
  Render.textureDraw = new PIXI.RenderTexture(Render.renderer, window.innerWidth, window.innerHeight, PIXI.SCALE_MODES.NEAREST)
  Render.textureVideo = new PIXI.RenderTexture(Render.renderer, window.innerWidth, window.innerHeight, PIXI.SCALE_MODES.NEAREST)
  Render.textureBuffer1 = new PIXI.RenderTexture(Render.renderer, window.innerWidth, window.innerHeight, PIXI.SCALE_MODES.NEAREST)
  Render.textureBuffer2 = new PIXI.RenderTexture(Render.renderer, window.innerWidth, window.innerHeight, PIXI.SCALE_MODES.NEAREST)

  // Layer video contains video sprite (rendered by textureVideo)
  Render.layerVideo.addChild(Render.spriteVideo)

  // Layer buffer effects (rendered by textureDraw)
  Render.layerBuffer1.addChild(new PIXI.Sprite(Render.textureBuffer1))
  Render.layerBuffer2.addChild(new PIXI.Sprite(Render.textureBuffer2))
  Render.currentBuffer = 0
  Render.textureBufferList = [Render.textureBuffer1, Render.textureBuffer2]
  Render.layerBufferList = [Render.layerBuffer1, Render.layerBuffer2]
  Render.getTextureBuffer = function () { return Render.textureBufferList[Render.currentBuffer] }
  Render.getLayerBuffer = function () { return Render.layerBufferList[Render.currentBuffer] }
  Render.nextBuffer = function () { Render.currentBuffer = (Render.currentBuffer + 1) % 2 }

  // Layer draw for display and persistence (rendered by webgl && textureBuffer)
  Render.layerDraw.addChild(new PIXI.Sprite(Render.textureDraw))

  Render.filters = []
  Render.currentFilter = 0
  Render.frameCount = 0
  Render.frameSkip = 0

  Render.setupUserMedia = false

  Render.textureUserMedia = Render.renderer.gl.createTexture()

  Render.addFilter = function (filter)
  {
    filter.video = Render.textureVideo
    filter.buffer = Render.getTextureBuffer()
    filter.pixelSize = 2.0
    filter.resolution = new Float32Array([window.innerWidth, window.innerHeight])
    Render.filters.push(filter)
  }

  Render.getFilter = function ()
  {
    return Render.filters[Render.currentFilter]
  }

  Render.nextFilter = function ()
  {
    Render.currentFilter = (Render.currentFilter + 1) % Render.filters.length
    Render.layerDraw.filters = [Render.getFilter()]
  }

  Render.init = function ()
  {
    Render.layerDraw.filters = [Render.getFilter()]
  }

  Render.update = function ()
  {
    ++Render.frameCount
    if (Render.frameCount >= Render.frameSkip)
    {
      Render.getFilter().time = Global.timeElapsed

      if (UserMedia.isReady)
      {
        Render.getFilter().frequenceTotal = UserMedia.frequenceTotal
                  // var gl = Render.renderer.gl
        // if (Render.setupUserMedia == false)
        // {
        //   Render.setupUserMedia = true
        //
        //   var renderTexture = new PIXI.RenderTexture(Render.renderer, UserMedia.frequenceByteData.length, 1, PIXI.SCALE_MODES.NEAREST)
        //   renderTexture.textureBuffer.texture = Render.textureUserMedia
        //   console.log(renderTexture)
        //
        //   gl.bindTexture(gl.TEXTURE_2D, Render.textureUserMedia);
        //   gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_S, gl.CLAMP_TO_EDGE);
        //   gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_T, gl.REPEAT);
        //   gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.LINEAR);
        //   gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, gl.LINEAR);
        //
        //   var tmp = new Uint8Array(UserMedia.frequenceByteData.length);
        //   gl.texImage2D(gl.TEXTURE_2D, 0, gl.ALPHA, UserMedia.frequenceByteData.length, 1, 0, gl.ALPHA, gl.UNSIGNED_BYTE, tmp);
        //
        // }

        // gl.bindTexture(gl.TEXTURE_2D, Render.textureUserMedia);
        // gl.pixelStorei(gl.UNPACK_ALIGNMENT, 1);
        // gl.texSubImage2D(gl.TEXTURE_2D, 0, 0, 0, UserMedia.frequenceByteData, 1, gl.ALPHA, gl.UNSIGNED_BYTE, UserMedia.frequenceByteData);
      }

      // Send previous frame to shader
      Render.getFilter().buffer = Render.getTextureBuffer()
      // Render video
      Render.textureVideo.render(Render.layerVideo)
      // Swap buffers (can not read and write a texture buffer a the same time)
      Render.nextBuffer()
      // Render effect
      Render.textureDraw.render(Render.getLayerBuffer())
      // Draw on screen
      Render.renderer.render(Render.layerDraw)
      // Save frame for persistence
      Render.getTextureBuffer().render(Render.layerDraw)

      Render.frameCount = 0
    }
  }

  return Render
})
