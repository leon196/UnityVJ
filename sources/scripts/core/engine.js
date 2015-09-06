
define(['../lib/pixi', '../core/utils'], function(PIXI, Utils)
{
  var Engine = {}

  Engine.init = function ()
  {
    Engine.renderer = PIXI.autoDetectRenderer(Engine.getWidth(), Engine.getHeight(), { view: document.getElementById("container"), antialias:true })
    Engine.stage = new PIXI.Container()
    Engine.scene = new PIXI.Container()
	}

  Engine.update = function ()
  {

  }

  Engine.getWidth = function () { return window.innerWidth }
  Engine.getHeight = function () { return window.innerHeight }
  window.onresize = function(event) { Engine.renderer.resize(Engine.getWidth(), Engine.getHeight()) }

  return Engine
})
