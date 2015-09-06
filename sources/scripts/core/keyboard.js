
define([], function()
{
  var Key = function (code)
  {
    this.down = false
    this.code = code
  }

  var Keyboard = {}

  Keyboard.P = new Key(80)

  Keyboard.onKeyDown = function (event)
  {
    for (var propertyName in Keyboard) {
      if (Keyboard.hasOwnProperty(propertyName) && Keyboard[propertyName] instanceof Key && event.keyCode == Keyboard[propertyName].code) {
        Keyboard[propertyName].down = true
      }
    }
  }

  Keyboard.onKeyUp = function (event)
  {
    for (var propertyName in Keyboard) {
      if (Keyboard.hasOwnProperty(propertyName) && Keyboard[propertyName] instanceof Key && event.keyCode == Keyboard[propertyName].code) {
        Keyboard[propertyName].down = false
      }
    }
  }

  return Keyboard
})
