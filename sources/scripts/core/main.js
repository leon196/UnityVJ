
define(['../lib/jquery', '../lib/pixi', '../core/engine', '../core/render',
'../core/loader', '../media/usermedia', '../base/animation'],
function($, PIXI, Engine, Render, Loader, UserMedia, Animation)
{
  function init ()
  {
    UserMedia.init()
    Render.init()
    Engine.init()
    animate()
  }

  function animate ()
	{
    UserMedia.update()
    Animation.update()
    Engine.update()
    Render.update()
		requestAnimFrame(animate)
	}

  Loader.loadFilters(init)
})
