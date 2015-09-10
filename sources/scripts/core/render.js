
define(['../lib/pixi', '../media/video', '../base/global', '../control/keyboard'], function(PIXI, Video, Global, Keyboard)
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
  Render.frameSkip = 2

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
