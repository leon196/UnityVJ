
define(['../lib/jquery', '../lib/pixi', '../core/engine', '../base/video', '../filters/glitch1', '../core/keyboard'],
function($, PIXI, Engine, Video, Glitch1Filter, Keyboard)
{
  Engine.init()

  var video = new Video('videos/dance.mp4')

  var backgroundVideo = new PIXI.Sprite(PIXI.Texture.fromVideo(video.DOM, PIXI.SCALE_MODES.NEAREST))
  backgroundVideo.width = Engine.getWidth()
  backgroundVideo.height = Engine.getHeight()
  Engine.layerVideo.addChild(backgroundVideo)

  var textureVideo = new PIXI.RenderTexture(Engine.renderer, Engine.getWidth(), Engine.getHeight(), PIXI.SCALE_MODES.NEAREST);
  var textureBuffer = new PIXI.RenderTexture(Engine.renderer, Engine.getWidth(), Engine.getHeight(), PIXI.SCALE_MODES.NEAREST);
  var textureDraw = new PIXI.RenderTexture(Engine.renderer, Engine.getWidth(), Engine.getHeight(), PIXI.SCALE_MODES.NEAREST);

  Engine.layerBuffer.addChild(new PIXI.Sprite(textureBuffer))
  Engine.layerDraw.addChild(new PIXI.Sprite(textureDraw))

  var glitch1Filter;
  $.ajax({
          url: 'scripts/filters/glitch1.frag',
          type: 'get',
          async: true,
          success: function(src) {
              glitch1Filter = new Glitch1Filter(src)
              Engine.layerBuffer.filters = [glitch1Filter]
              glitch1Filter.video = textureVideo
              glitch1Filter.buffer = textureBuffer
              glitch1Filter.pixelSize = 2.0
              glitch1Filter.resolution = new Float32Array([Engine.getWidth(), Engine.getHeight()])
          }
  });

  function animate ()
	{
    Engine.update()

    if (Keyboard.P.down) {
      Engine.pause = !Engine.pause
      Keyboard.P.down = false
    }


    if (!Engine.pause) {
      textureVideo.render(Engine.layerVideo)
    }

    textureDraw.render(Engine.layerBuffer)
		Engine.renderer.render(Engine.layerDraw)
    textureBuffer.render(Engine.layerDraw)


    if (glitch1Filter) {
      glitch1Filter.time = Engine.timeElapsed
      //glitch1Filter.pixelSize = 1.0 + Math.ceil(Engine.mouse.x * 8 / Engine.getWidth())
    }

		requestAnimFrame(animate)
	}

  Engine.layerDraw.interactive = true
  Engine.layerDraw.on('mousedown', Engine.onClic).on('touchstart', Engine.onClic)
  Engine.layerDraw.on('mousemove', Engine.onMove).on('touchmove', Engine.onMove)
  document.addEventListener('keydown', Keyboard.onKeyDown)
  document.addEventListener('keyup', Keyboard.onKeyUp)

  animate()
})
