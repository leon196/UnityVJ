
define(['../lib/jquery', '../core/filter', '../core/render'], function($, Filter, Render)
{
  var Loader = {}

  Loader.filterLoaded = 0
  Loader.filtersToLoad = ['glitch1', 'kaleido']

  Loader.loadFilters = function (onComplete)
  {
    Loader.onComplete = onComplete
    var filtersPath = 'shaders/'
    var filtersExtension = '.frag'

    for (var f = 0; f < Loader.filtersToLoad.length; ++f)
    {
      $.ajax({ url: filtersPath + Loader.filtersToLoad[f] + filtersExtension,
        type: 'get', async: true, success: Loader.loadedFilter });
    }
  }

  Loader.loadedFilter = function (src)
  {
    var filter = new Filter(src)
    Render.addFilter(filter)

    ++Loader.filterLoaded
    if (Loader.filterLoaded == Loader.filtersToLoad.length && Loader.onComplete)
    {
      Loader.onComplete()
    }
  }

  return Loader
})
