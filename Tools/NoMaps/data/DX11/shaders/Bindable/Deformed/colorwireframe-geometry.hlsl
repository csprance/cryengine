/////////////
// GLOBALS //
/////////////
cbuffer MatrixBuffer : register(b0)
{
    matrix wvpMatrix;
    matrix wldMatrix;
    float3 eyeVector;
};

//////////////
// TYPEDEFS //
//////////////
struct GeometryInputType
{
    float4 position : SV_Position;
};

struct PixelInputType
{
    float4 position : SV_Position;
    
    float3 barypos : BARYPOS;
};

////////////////////////////////////////////////////////////////////////////////
// Geometry Shader
////////////////////////////////////////////////////////////////////////////////
[maxvertexcount(3)]
void RenderSceneGS(triangle GeometryInputType input[3], inout TriangleStream<PixelInputType> output)
{
  PixelInputType tri;
  
  /* pass through the three connected vertices to all fragments of the triangle */
  [unroll]
  for (uint i = 0; i < 3; i++) {
    tri.position  = input[i].position;
    
    /* as the interpolator in the rasterizer is working
     * barycentric, this will automatically return the
     * exact barycentric coordinates of the position
     * of the pixel in the pixel shader
     */
    tri.barypos   = float3(i == 0 ? 1 : 0, i == 1 ? 1 : 0, i == 2 ? 1 : 0);

    output.Append(tri);
  }
  
  output.RestartStrip();
}
