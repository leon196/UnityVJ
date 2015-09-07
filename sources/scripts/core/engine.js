
define(['../lib/pixi', '../core/utils', '../core/render', '../core/mouse', '../core/keyboard'],
function(PIXI, Utils, Render, Mouse, Keyboard)
{
  var Engine = {}

  Engine.pause = false
  Engine.timeStarted = new Date() / 1000
  Engine.timeElapsed = 0

  Engine.init = function ()
  {
    // Events
    Render.layerDraw.interactive = true
    Render.layerDraw.on('mousedown', Mouse.onClic).on('touchstart', Mouse.onClic)
    Render.layerDraw.on('mouseup', Mouse.onMouseUp)
    Render.layerDraw.on('mousemove', Mouse.onMove).on('touchmove', Mouse.onMove)
    document.addEventListener('keydown', Keyboard.onKeyDown)
    document.addEventListener('keyup', Keyboard.onKeyUp)
	}

  Engine.update = function ()
  {
    Engine.timeElapsed = new Date() / 1000 - Engine.timeStarted

    if (Keyboard.P.down)
    {
      Engine.pause = !Engine.pause
      Keyboard.P.down = false
    }

    //Engine.layerDraw.scale.x = Engine.layerDraw.scale.y = 1 + Engine.mouse.x * 8 / Engine.getWidth()
    // Engine.layerDraw.x = offsetPan.x + (Engine.layerDraw.scale.x - 1) * -Engine.getWidth() / 2
    // Engine.layerDraw.y = offsetPan.y + (Engine.layerDraw.scale.y - 1) * -Engine.getHeight() / 2

    Render.getFilter().time = Engine.timeElapsed
    //Render.getFilter().pixelSize = 1.0 + Math.ceil(Engine.mouse.x * 8 / Engine.getWidth())

    Render.update()
  }

  Engine.getWidth = function () { return window.innerWidth }
  Engine.getHeight = function () { return window.innerHeight }
  window.onresize = function(event) { Engine.renderer.resize(Engine.getWidth(), Engine.getHeight()) }

  return Engine
})
