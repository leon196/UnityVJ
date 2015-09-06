
define(['../lib/pixi'], function (PIXI)
{

  function Glitch1Filter(fragmentSrc)
  {
      PIXI.AbstractFilter.call(this,
          // vertex shader
          null,
          // fragment shader
          fragmentSrc,
          // custom uniforms
          {
              dimensions: { type: '4fv', value: new Float32Array([0, 0, 0, 0]) },
              pixelSize:  { type: '1f', value: 8 },
              buffer: { type: 'sampler2D', value: 0 }
          }
      );
  }


  Glitch1Filter.prototype = Object.create(PIXI.AbstractFilter.prototype);
  Glitch1Filter.prototype.constructor = Glitch1Filter;

  Object.defineProperties(Glitch1Filter.prototype, {
      size: {
          get: function () {
              return this.uniforms.pixelSize.value;
          },
          set: function (value) {
              this.uniforms.pixelSize.value = value;
          }
      }
  });

  Object.defineProperties(Glitch1Filter.prototype, {
      buffer: {
          set: function (value) {
              this.uniforms.buffer.value = value;
          }
      }
  });

  return Glitch1Filter
})
