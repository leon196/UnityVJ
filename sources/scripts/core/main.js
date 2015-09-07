
define(['../lib/jquery', '../lib/pixi', '../core/engine', '../core/render', '../filters/glitch1'],
function($, PIXI, Engine, Render, Glitch1Filter)
{
  var filtersPath = 'scripts/filters/'
  var filtersExtension = '.frag'
  var filtersToLoad = ['glitch1']
  var filterLoaded = 0

  for (var f = 0; f < filtersToLoad.length; ++f)
  {
    $.ajax({ url: filtersPath + filtersToLoad[f] + filtersExtension, type: 'get', async: true, success: loadedFilter });
  }

  function loadedFilter (src)
  {
    var filter = new Glitch1Filter(src)
    Render.addFilter(filter)
    ++filterLoaded
    if (filterLoaded == filtersToLoad.length)
    {
      Render.init()
      Engine.init()
      animate()
    }
  }

  function animate ()
	{
    Engine.update()
		requestAnimFrame(animate)
	}
})
