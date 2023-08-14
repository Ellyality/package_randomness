#if !defined(NORMAL_NOISE)
	#if !defined(SIMPLEX)
		#include "./simplex.cginc"
	#endif

	FLOAT3 normalNoise(FLOAT2 _st, float _zoom, float _speed, float time){
		FLOAT2 v1 = _st;
		FLOAT2 v2 = _st;
		FLOAT2 v3 = _st;
		float expon = pow(10.0, _zoom*2.0);
		v1 /= 1.0*expon;
		v2 /= 0.62*expon;
		v3 /= 0.83*expon;
		float n = time*_speed;
		float nr = (classic_simplex3D(FLOAT3(v1, n)) + classic_simplex3D(FLOAT3(v2, n)) + classic_simplex3D(FLOAT3(v3, n))) / 6.0 + 0.5;
		n = time * _speed + 1000.0;
		float ng = (classic_simplex3D(FLOAT3(v1, n)) + classic_simplex3D(FLOAT3(v2, n)) + classic_simplex3D(FLOAT3(v3, n))) / 6.0 + 0.5;
		return FLOAT3(nr,ng,0.5);
	}
	
    #define NORMAL_NOISE
#endif