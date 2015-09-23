
define(['../base/utils'], function(Utils)
{
  var Mouse = {}

  Mouse.x = 0
  Mouse.y = 0
  Mouse.down = false
  Mouse.moveMode = true

  // Pan
  Mouse.pan = {x:window.innerWidth/4, y:window.innerHeight/4}
  Mouse.panStart = {x:0, y:0}
  Mouse.panStarted = false

	Mouse.onMove = function(event)
	{
		Mouse.x = event.data.global.x
		Mouse.y = event.data.global.y
    if (Mouse.panStarted)
    {
      Mouse.pan.x = Utils.clamp(Mouse.x - Mouse.panStart.x, 0, window.innerWidth)
      Mouse.pan.y = Utils.clamp(Mouse.y - Mouse.panStart.y, 0, window.innerHeight)
    }
	}

	Mouse.onClic = function(event)
	{
		Mouse.x = event.data.global.x
		Mouse.y = event.data.global.y
  	Mouse.down = true

    // Pan
    Mouse.panStart.x = Mouse.x - Mouse.pan.x
    Mouse.panStart.y = Mouse.y - Mouse.pan.y
    Mouse.panStarted = true

    // Move mode
    Mouse.moveMode = !Mouse.moveMode
    if (Mouse.moveMode) {
      document.getElementById('container').style.cursor = 'move'
    } else {
      document.getElementById('container').style.cursor = 'pointer'
    }
	}

	Mouse.onMouseUp = function(event)
	{
		Mouse.down = false
    Mouse.panStarted = false
	}

  return Mouse
})
