define([], function ()
{
	var Utils = {}

	Utils.PI2 = Math.PI * 2

	Utils.mix = function(a, b, ratio) { return a * (1 - ratio) + b * ratio }
	Utils.clamp = function(v, min, max) { return Math.max(min, Math.min(v, max)) }
	Utils.length = function(x, y) { return Math.sqrt(x*x+y*y) }
	Utils.distanceBetween = function(p1, p2) { return Utils.length(p2.x - p1.x, p2.y - p1.y) }
	Utils.distance = function(x1, y1, x2, y2) { return Utils.length(x2 - x1, y2 - y1) }
	Utils.normalize = function (v) { var dist = Utils.length(v.x, v.y); return { x: v.x / dist, y: v.y / dist }; }

	// http://www.paulirish.com/2011/requestanimationframe-for-smart-animating/
	window.requestAnimFrame = (function(){
  return  window.requestAnimationFrame       ||
          window.webkitRequestAnimationFrame ||
          window.mozRequestAnimationFrame    ||
          window.oRequestAnimationFrame      ||
          window.msRequestAnimationFrame     ||
          function(callback, element){
            window.setTimeout(callback, 1000 / 60);
          };
})();

	return Utils
})
