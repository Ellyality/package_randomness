
#if !defined(PERLIN)
	#if !defined(RANDOMNESS)
		#include "./randomness.cginc"
	#endif

	#define M_PI 3.14159265358979323846
	float rand_p2 (FLOAT2 co, float l) {return rand(FLOAT2(rand(co), l));}
	float rand_p2 (FLOAT2 co, float l, float t) {return rand(FLOAT2(rand_p2(co, l), t));}

	float perlin(FLOAT2 p, float dim, float time) {
		FLOAT2 pos = floor(p * dim);
		FLOAT2 posx = pos + FLOAT2(1.0, 0.0);
		FLOAT2 posy = pos + FLOAT2(0.0, 1.0);
		FLOAT2 posxy = pos + FLOAT2(1.0, 1.0);
	
		float c = rand_p2(pos, dim, time);
		float cx = rand_p2(posx, dim, time);
		float cy = rand_p2(posy, dim, time);
		float cxy = rand_p2(posxy, dim, time);
	
		FLOAT2 d = FRACT(p * dim);
		d = -0.5 * cos(d * M_PI) + 0.5;
	
		float ccx = LERP(c, cx, d.x);
		float cycxy = LERP(cy, cxy, d.x);
		float center = LERP(ccx, cycxy, d.y);
	
		return center * 2.0 - 1.0;
	}

	// p must be normalized!
	float perlin(FLOAT2 p, float dim) {
	
		/*FLOAT2 pos = floor(p * dim);
		FLOAT2 posx = pos + FLOAT2(1.0, 0.0);
		FLOAT2 posy = pos + FLOAT2(0.0, 1.0);
		FLOAT2 posxy = pos + FLOAT2(1.0);
	
		// For exclusively black/white noise
		/*float c = step(rand(pos, dim), 0.5);
		float cx = step(rand(posx, dim), 0.5);
		float cy = step(rand(posy, dim), 0.5);
		float cxy = step(rand(posxy, dim), 0.5);*/
	
		/*float c = rand(pos, dim);
		float cx = rand(posx, dim);
		float cy = rand(posy, dim);
		float cxy = rand(posxy, dim);
	
		FLOAT2 d = fract(p * dim);
		d = -0.5 * cos(d * M_PI) + 0.5;
	
		float ccx = LERP(c, cx, d.x);
		float cycxy = LERP(cy, cxy, d.x);
		float center = LERP(ccx, cycxy, d.y);
	
		return center * 2.0 - 1.0;*/
		return perlin(p, dim, 0.0);
	}

	#define PERLIN
#endif