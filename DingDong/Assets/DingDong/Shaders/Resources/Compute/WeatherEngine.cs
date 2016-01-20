using UnityEngine;
using System.Collections;


public struct WeatherSquare
{
    public float x;
    public float y;
    public float z;
}

public class WeatherEngine
{
    private ComputeShader computeFronts;
    private int computeFrontsThread1DNbr = 64;
    private string computeFrontsKernelName = "computeFronts";
    private int computeFrontsKernelIndex;

    private ComputeShader computeNormaliseFronts;
    private int computeNormaliseFrontsThread1DNbr = 64;
    private string computeNormaliseFrontsKernelName = "computeNormaliseFronts";
    private int computeNormaliseFrontsKernelIndex;

    private ComputeBuffer weatherGridBuffer;
    private ComputeBuffer weatherTamponBuffer;

    private int gridWidth = 1024;
    private int gridHeight = 1024;

    private WeatherSquare[] weatherGrid;

    public WeatherEngine()
    {

        weatherGrid = new WeatherSquare[gridWidth * gridHeight];
        {
            for (int i = 0; i < weatherGrid.Length; i++)
            {
                weatherGrid[i] = new WeatherSquare();
            }
        }

        weatherGridBuffer = new ComputeBuffer(gridWidth * gridHeight, sizeof(float)*3);
        weatherGridBuffer.SetData(weatherGrid);

        weatherTamponBuffer = new ComputeBuffer(gridWidth * gridHeight, sizeof(float) * 3);

        computeFronts = ReferencesPrototype.weatherGridParamaters.computeFrontsShader;
        computeFrontsKernelIndex = computeFronts.FindKernel(computeFrontsKernelName);
        computeFronts.SetBuffer(computeFrontsKernelIndex, "weatherGridBuffer", weatherGridBuffer);
        computeFronts.SetBuffer(computeFrontsKernelIndex, "weatherTamponBuffer", weatherTamponBuffer);

        computeNormaliseFronts = ReferencesPrototype.weatherGridParamaters.computeNormaliseFrontsShader;
        computeNormaliseFrontsKernelIndex = computeFronts.FindKernel(computeNormaliseFrontsKernelName);
        computeNormaliseFronts.SetBuffer(computeNormaliseFrontsKernelIndex, "weatherGridBuffer", weatherGridBuffer);
        computeNormaliseFronts.SetBuffer(computeNormaliseFrontsKernelIndex, "weatherTamponBuffer", weatherTamponBuffer);

        var index = 10 + 10 * gridWidth;
        Debug.Log(weatherGrid[index].x);

        computeFronts.Dispatch(computeFrontsKernelIndex, gridWidth * gridHeight / computeFrontsThread1DNbr, 1, 1);
        weatherGridBuffer.GetData(weatherGrid);

        Debug.Log(weatherGrid[index].x);

        computeNormaliseFronts.Dispatch(computeNormaliseFrontsKernelIndex, gridWidth * gridHeight / computeNormaliseFrontsThread1DNbr, 1, 1);
        weatherGridBuffer.GetData(weatherGrid);

        Debug.Log(weatherGrid[index].x);
    }


    /*public WeatherEngine()
    {
        computeShader = 
        kernelIndex = computeShader.FindKernel(kernelName);
        InitData();
        InitBuffer();
    }*/

    private void InitData()
    {
       /* data = new Vector3[ReferencesPrototype.weatherGridParamaters.x * ReferencesPrototype.weatherGridParamaters.y];
        for (int i = 0; i < data.Length; i++)
        {
            data[i] = new Vector3(1,1,1);
        }*/
    }

    public void InitBuffer()
    {
        
    }
    
    public void UpdateEngine()
    {
        
    }

    public Texture GetRenderTexture()
    {
        return null;
    }

    public void StopGPGPUComputing()
    {
        weatherGridBuffer.Dispose();
        weatherTamponBuffer.Dispose();
    }

    public void ShowData()
    {
       
    }

}
