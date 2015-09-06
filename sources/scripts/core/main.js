
define(['../lib/jquery', '../lib/pixi', '../core/engine', '../base/video', '../filters/glitch1'], function($, PIXI, Engine, Video, Glitch1Filter)
{
  Engine.init()

  var video = new Video('videos/vh1.ogv')

  var background = new PIXI.Sprite(PIXI.Texture.fromVideo(video.DOM))
  background.width = Engine.getWidth()
  background.height = Engine.getHeight()
  Engine.scene.addChild(background)

  var renderTexture1 = new PIXI.RenderTexture(Engine.renderer, Engine.getWidth(), Engine.getHeight());
  var renderTexture2 = new PIXI.RenderTexture(Engine.renderer, Engine.getWidth(), Engine.getHeight());

  Engine.stage.addChild(new PIXI.Sprite(renderTexture1))
  //Engine.stage.addChild(new PIXI.Sprite(renderTexture2))

  var glitch1Filter;
  $.ajax({
          url: 'scripts/filters/glitch1.frag',
          type: 'get',
          async: true,
          success: function(src) {
              glitch1Filter = new Glitch1Filter(src)
              Engine.scene.filters = [glitch1Filter]
          }
  });

  function animate ()
	{
    Engine.update()

    renderTexture1.render(Engine.scene)

		Engine.renderer.render(Engine.stage)
    renderTexture2.render(Engine.stage)

    if (glitch1Filter) {
      glitch1Filter.buffer = renderTexture2
    }

		requestAnimFrame(animate)
	}

  animate()
})
