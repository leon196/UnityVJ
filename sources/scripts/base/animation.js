
define(['../core/global', '../core/utils'], function(Global, Utils)
{
  var Timing = function (once, delay, onUpdate, onComplete)
  {
    this.once = typeof once !== "undefined" ? once : true
    this.ratio = 0
    this.timeStart = -delay
    this.timeDelay = delay
    this.onUpdate = typeof onUpdate !== "undefined" ? onUpdate : function(){}
    this.onComplete = typeof onComplete !== "undefined" ? onComplete : function(){}
    this.complete = false

    this.start = function ()
    {
      this.timeStart = Global.timeElapsed
      this.complete = false
    }

    this.update = function ()
    {
      this.ratio = (Global.timeElapsed - this.timeStart) / this.timeDelay
      this.ratio = Utils.clamp(this.ratio, 0, 1)
      this.onUpdate(this.ratio)
      if (this.ratio >= 1 && this.complete == false) {
        this.complete = true
        this.onComplete()
        if (this.once) {
          Animation.remove(this)
        }
      }
    }
  }

  var Animation = {}

  Animation.list = []
  Animation.garbage = []

  Animation.add = function (once, delay, onUpdate, onComplete)
  {
    var timing = new Timing(once, delay, onUpdate, onComplete)
    Animation.list.push(timing)
    return timing
  }

  Animation.update = function ()
  {
    Animation.recycle()
    for (var i = 0; i < Animation.list.length; ++i)
    {
      var timing = Animation.list[i]
      timing.update()
    }
  }

  Animation.remove = function (anim)
  {
    Animation.garbage.push(Animation.list.indexOf(anim))
  }

  Animation.recycle = function ()
  {
    if (Animation.garbage.length > 0)
    {
      for (var i = Animation.garbage.length - 1; i >= 0; --i)
      {
        var animIndex = Animation.garbage[i]
        Animation.list.splice(animIndex, 1)
      }
      Animation.garbage = []
    }
  }

  return Animation
})
