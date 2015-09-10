
define(['../lib/pixi', '../core/render',
'../control/mouse', '../control/keyboard',
'../base/utils', '../base/global', '../base/animation'],
function(PIXI, Render, Mouse, Keyboard, Utils, Global, Animation)
{
  var Engine = {}

  Engine.init = function ()
  {
    // Events
    Render.layerDraw.interactive = true
    Render.layerDraw.on('mousedown', Mouse.onClic).on('touchstart', Mouse.onClic)
    Render.layerDraw.on('mouseup', Mouse.onMouseUp)
    Render.layerDraw.on('mousemove', Mouse.onMove).on('touchmove', Mouse.onMove)
    document.addEventListener('keydown', Keyboard.onKeyDown)
    document.addEventListener('keyup', Keyboard.onKeyUp)

    Global.timeStarted = new Date() / 1000
    Global.timeElapsed = 0

    Engine.impulse = new Animation.add(false, 1, function(ratio){
      ratio = 1 - Math.sin(ratio*Utils.PI2)
      Render.getFilter().bufferTreshold = ratio * 0.5 + 0.25
    })
	}

  Engine.update = function ()
  {
    Global.timeElapsed = new Date() / 1000 - Global.timeStarted

    if (Keyboard.P.down)
    {
      Global.pause = !Global.pause
      Keyboard.P.down = false
      if (Global.pause)
      {
        Render.video.pause()
      }
      else
      {
        Render.video.play()
      }
    }

    if (Keyboard.Left.down)
    {
      Render.nextFilter()
      Keyboard.Left.down = false
    }

    if (Keyboard.Space.down)
    {
      Engine.impulse.start()
      Keyboard.Space.down = false
    }

    //Engine.layerDraw.scale.x = Engine.layerDraw.scale.y = 1 + Engine.mouse.x * 8 / Engine.getWidth()
    // Engine.layerDraw.x = offsetPan.x + (Engine.layerDraw.scale.x - 1) * -Engine.getWidth() / 2
    // Engine.layerDraw.y = offsetPan.y + (Engine.layerDraw.scale.y - 1) * -Engine.getHeight() / 2

    Render.getFilter().time = Global.timeElapsed
    //Render.getFilter().pixelSize = 1.0 + Math.ceil(Engine.mouse.x * 8 / Engine.getWidth())

    Animation.update()
    Render.update()
  }

  Engine.getWidth = function () { return window.innerWidth }
  Engine.getHeight = function () { return window.innerHeight }

  return Engine
})
