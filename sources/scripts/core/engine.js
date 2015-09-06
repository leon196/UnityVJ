
define(['../lib/pixi', '../core/utils'], function(PIXI, Utils)
{
  var Engine = {}

  Engine.pause = false
  Engine.timeStarted = new Date() / 1000
  Engine.timeElapsed = 0
  Engine.mouse = {x:0, y:0, down:false }

  Engine.init = function ()
  {
    Engine.renderer = PIXI.autoDetectRenderer(Engine.getWidth(), Engine.getHeight(), { view: document.getElementById("container") })
    Engine.layerVideo = new PIXI.Container()
    Engine.layerBuffer = new PIXI.Container()
    Engine.layerDraw = new PIXI.Container()
	}

  Engine.update = function ()
  {
    Engine.timeElapsed = new Date() / 1000 - Engine.timeStarted
  }

	Engine.onMove = function(event)
	{
		Engine.mouse = event.data.global
	}

	Engine.onClic = function(event)
	{
		Engine.mouse = event.data.global
  	Engine.mouse.down = true
	}

	Engine.onMouseUp = function(event)
	{
		Engine.mouse.down = false
	}

  Engine.getWidth = function () { return window.innerWidth }
  Engine.getHeight = function () { return window.innerHeight }
  window.onresize = function(event) { Engine.renderer.resize(Engine.getWidth(), Engine.getHeight()) }

  return Engine
})
