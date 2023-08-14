# Elly Randomness

## Description

## Install Package

[Scoped Registery](https://github.com/Ellyality/.github/blob/main/profile/README.md)

Then install Elly Random in the package manager (my registery)

## Custom Shader

In the shader, Use include to import shader to your custom shader scripts.

#### defined

use #define to predefined the const variables

* SEED -> Use random seed, Default is 43758.5453123
* OCTAVES -> the octaves for [fbm](https://thebookofshaders.com/13/) function, Default is 1
* GAIN -> the gain for [fbm](https://thebookofshaders.com/13/) function, Default is 0.5
* LACUNARITY -> the lacunarity for [fbm](https://thebookofshaders.com/13/) function, Default is 2.0

#### noise core

#include "Packages/com.ellyality.random.core/Resources/Randomness/randomness.cginc"

simple rand gen functions

* float rand(float n)
* float rand(float2 n)
* float hash(float n)
* float hash(float2 p) 
* float4 perm(float4 x)

the noise functions

* float noise(float p)
* float noise_V2(float p)
* float noise(float2 p)
* float noise_V2(float2 p)
* float noise_V3(float2 p)
* float noise(float3 p)
* float noise_V2(float3 p)

#### perlin noise

#include "Packages/com.ellyality.random.core/Resources/Randomness/perlin.cginc"

* float perlin(FLOAT2 p, float dim, float time)
* float perlin(FLOAT2 p, float dim)
* float classic_perlin2D(float2 P)
* float classic_perlin3D(float3 P)
* classic_perlin2D_fbm(float2 p)

#### simplex noise

#include "Packages/com.ellyality.random.core/Resources/Randomness/simplex.cginc"

* float classic_simplex3D(float3 p)
* float classic_simplex2D(float2 p)
* float classic_simplex3D_fbm(float3 p)
* float classic_simplex2D_fbm(float2 p)

#### normal noise

#include "Packages/com.ellyality.random.core/Resources/Randomness/normal.cginc"

* float3 normalNoise(float2 uv, float _zoom, float _speed, float time)

#### voronoi noise

#include "Packages/com.ellyality.random.core/Resources/Randomness/voronoi.cginc"

* float voronoi(float2 x, float time)
* float voronoi_fbm(float2 p, float time)

#### curl noise

#include "Packages/com.ellyality.random.core/Resources/Randomness/curl.cginc"

* float2 ComputeCurl(float2 Coord, float tValue, float2 StepSize, float FlowMultiplier)