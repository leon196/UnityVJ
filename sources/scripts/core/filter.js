
define(['../lib/pixi', '../base/global'], function (PIXI, Global)
{
  function Filter(fragmentSrc)
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
              ,uMouse:  { type: '2fv', value: new Float32Array([0, 0]) }
              ,uMousePan:  { type: '2fv', value: new Float32Array([0, 0]) }
              ,uPixelSize:  { type: '1f', value: 1 }
              ,uFrequenceTotal:  { type: '1f', value: 0 }
              ,uBuffer: { type: 'sampler2D', value: 0 }
              ,uFrequenceTexture: { type: 'sampler2D', value: 0 }
              ,uImage: { type: 'sampler2D', value: 0 }
              ,uVideo: { type: 'sampler2D', value: 0 }
              ,uAngleX: { type: '1f', value: 0 }
              ,uAngleY: { type: '1f', value: 0 }
              ,uBufferTreshold: { type: '1f', value: Global.bufferTreshold }
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
      )
  }

  Filter.prototype = Object.create(PIXI.AbstractFilter.prototype)
  Filter.prototype.constructor = Filter

  Object.defineProperties(Filter.prototype, {
    resolution  :{set:function(value){
      this.uniforms.uResolution.value  =value}}
  })
  Object.defineProperties(Filter.prototype, {
    time  :{set:function(value){
      this.uniforms.uTime.value  =value}}
  })
  Object.defineProperties(Filter.prototype, {
    mouse  :{set:function(value){
      this.uniforms.uMouse.value[0]  = value.x
      this.uniforms.uMouse.value[1]  = value.y
    }}
  })
  Object.defineProperties(Filter.prototype, {
    mousePan  :{set:function(value){
      this.uniforms.uMousePan.value[0]  = value.x
      this.uniforms.uMousePan.value[1]  = value.y
    }}
  })
  Object.defineProperties(Filter.prototype, {
    mouseX  :{set:function(value){
      this.uniforms.uMouse.value[0]  = value
    }}
  })
  Object.defineProperties(Filter.prototype, {
    mouseY  :{set:function(value){
      this.uniforms.uMouse.value[1]  = value
    }}
  })
  Object.defineProperties(Filter.prototype, {
    frequenceTotal  :{set:function(value){
      this.uniforms.uFrequenceTotal.value  =value}}
  })
  Object.defineProperties(Filter.prototype, {
    pixelSize  :{set:function(value){
      this.uniforms.uPixelSize.value  =value}}
  })
  Object.defineProperties(Filter.prototype, {
    buffer  :{set:function(value){
      this.uniforms.uBuffer.value  =value}}
  })
  Object.defineProperties(Filter.prototype, {
    video  :{set:function(value){
      this.uniforms.uVideo.value  =value}}
  })
  Object.defineProperties(Filter.prototype, {
    image  :{set:function(value){
      this.uniforms.uImage.value  =value}}
  })
  Object.defineProperties(Filter.prototype, {
    frequenceTexture  :{set:function(value){
      this.uniforms.uFrequenceTexture.value  =value}}
  })
  Object.defineProperties(Filter.prototype, {
    bufferTreshold  :{set:function(value){
      this.uniforms.uBufferTreshold.value  =value}}
  })
  Object.defineProperties(Filter.prototype, {
    angleX  :{set:function(value){
      this.uniforms.uAngleX.value  =value}}
  })
  Object.defineProperties(Filter.prototype, {
    angleY  :{set:function(value){
      this.uniforms.uAngleY.value  =value}}
  })

  return Filter
})
