
define(['../lib/jquery', '../lib/pixi', '../core/engine', '../core/render', '../core/loader'],
function($, PIXI, Engine, Render, Loader)
{
  function init ()
  {
    Render.init()
    Engine.init()
    animate()
  }

  function animate ()
	{
    Engine.update()
		requestAnimFrame(animate)
	}

  Loader.loadFilters(init)
})
