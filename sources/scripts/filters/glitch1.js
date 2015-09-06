
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
              uResolution: { type: '2fv', value: new Float32Array([0, 0]) }
              ,uTime:  { type: '1f', value: 0 }
              ,uPixelSize:  { type: '1f', value: 1 }
              ,uBuffer: { type: 'sampler2D', value: 0 }
              ,uVideo: { type: 'sampler2D', value: 0 }
              ,uFilter5x5Gaussian: { type: '1fv', value: new Float32Array([
          			-1,-1,-1,-1,-1,
          			-1,-1,-1,-1,-1,
          			-1,-1,24,-1,-1,
          			-1,-1,-1,-1,-1,
          			-1,-1,-1,-1,-1]) }
              ,uFilter5x5Neighbor: { type: '1fv', value: new Float32Array([
                0.04,0.04,0.04,0.04,0.04,
          			0.04,0.04,0.04,0.04,0.04,
          			0.04,0.04,0.04,0.04,0.04,
          			0.04,0.04,0.04,0.04,0.04,
          			0.04,0.04,0.04,0.04,0.04]) }
              ,uFilter3x3Neighbor: { type: '1fv', value: new Float32Array([
                1/9,1/9,1/9,
                1/9,1/9,1/9,
                1/9,1/9,1/9]) }
          }
      );
  }


  Glitch1Filter.prototype = Object.create(PIXI.AbstractFilter.prototype);
  Glitch1Filter.prototype.constructor = Glitch1Filter;

  Object.defineProperties(Glitch1Filter.prototype, {
      resolution: {
          set: function (value) {
              this.uniforms.uResolution.value = value;
          }
      }
  });

  Object.defineProperties(Glitch1Filter.prototype, {
      time: {
          set: function (value) {
              this.uniforms.uTime.value = value;
          }
      }
  });

  Object.defineProperties(Glitch1Filter.prototype, {
      pixelSize: {
          set: function (value) {
              this.uniforms.uPixelSize.value = value;
          }
      }
  });

  Object.defineProperties(Glitch1Filter.prototype, {
      buffer: {
          set: function (value) {
              this.uniforms.uBuffer.value = value;
          }
      }
  });

  Object.defineProperties(Glitch1Filter.prototype, {
      video: {
          set: function (value) {
              this.uniforms.uVideo.value = value;
          }
      }
  });

  return Glitch1Filter
})
