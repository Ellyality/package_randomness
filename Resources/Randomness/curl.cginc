#if !defined(CURL)
	#if !defined(SIMPLEX)
		#include "./simplex.cginc"
	#endif

	float TiledNoise(FLOAT2 Coord )
    {
        float U = Coord.x * 2.0 * 3.14159;
        float V = Coord.y * 2.0 * 3.14159;
        float A = 0.5;
        float C = 1.20;
    
	    float X = (C + A * cos(V)) * cos(U);
        float Y = (C + A * cos(V)) * sin(U);
        float Z = A * sin(V);
    
        return classic_simplex3D_fbm(FLOAT3(X, Y, Z));
    }

    // interpolate between two noise samples offset by 0.5 in each dimension
    float InterpolatedNoise(FLOAT2 Coord, float tValue )
    {
	    float NoiseSampleA = TiledNoise(Coord);
        float NoiseSampleB = TiledNoise(Coord + FLOAT2(0.5,0.5));
	    return LERP(NoiseSampleA, NoiseSampleB, tValue);
    }

    // calculate the Curl using finite differences with 4 samples in each direction
    FLOAT2 ComputeCurl(FLOAT2 Coord, float tValue, FLOAT2 StepSize, float FlowMultiplier )
    {
        // integration using 5 points
        // ( n1 - 8n2 + 8n3 - n4 ) / (12 * t)
        // where n1 is f(x - 2t), n2 is f(x - t), n3 is f(x + t), and n4 is f(x + 2t)
    
        // vertical direction
        float n1 = InterpolatedNoise(Coord - FLOAT2(0.0, 2.0 * StepSize.y), tValue) * FlowMultiplier;
        float n2 = InterpolatedNoise(Coord - FLOAT2(0.0, 1.0 * StepSize.y), tValue) * FlowMultiplier;
        float n3 = InterpolatedNoise(Coord + FLOAT2(0.0, 1.0 * StepSize.y), tValue) * FlowMultiplier;
        float n4 = InterpolatedNoise(Coord + FLOAT2(0.0, 2.0 * StepSize.y), tValue) * FlowMultiplier;
    
        float a = (n1 - 8.0 * n2 + 8.0 * n3 - n4) * (1.0 / 12.0);
    
        // horizontal direction
   	    n1 = InterpolatedNoise(Coord - FLOAT2(2.0 * StepSize.x, 0.0), tValue) * FlowMultiplier;
        n2 = InterpolatedNoise(Coord - FLOAT2(1.0 * StepSize.x, 0.0), tValue) * FlowMultiplier;
        n3 = InterpolatedNoise(Coord + FLOAT2(1.0 * StepSize.x, 0.0), tValue) * FlowMultiplier;
        n4 = InterpolatedNoise(Coord + FLOAT2(2.0 * StepSize.x, 0.0), tValue) * FlowMultiplier;
    
        float b = (n1 - 8.0 * n2 + 8.0 * n3 - n4) * (1.0 / 12.0);
                 
        return FLOAT2(a, -b);
    }


    #define CURL
#endif