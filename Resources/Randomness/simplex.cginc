#if !defined(SIMPLEX)
	#if !defined(RANDOMNESS)
		#include "./randomness.cginc"
	#endif

	FLOAT3 random3(FLOAT3 c) {
		float j = 4096.0*sin(dot(c,FLOAT3(17.0, 59.4 * SEED, 15.0)));
		FLOAT3 r;
		r.z = FRACT(0.1031*j);
		j *= .125;
		r.x = FRACT(0.11369*j);
		j *= .125;
		r.y = FRACT(0.13787*j);
		return r-0.5;
	}

	/* skew constants for 3d simplex functions */
	const float F3 =  0.3333333;
	const float G3 =  0.1666667;

	/* 3d simplex noise */
	float classic_simplex3D(FLOAT3 p) {
		 /* 1. find current tetrahedron T and it's four vertices */
		 /* s, s+i1, s+i2, s+1.0 - absolute skewed (integer) coordinates of T vertices */
		 /* x, x1, x2, x3 - unskewed coordinates of p relative to each of T vertices*/
	 
		 /* calculate s and x */
		 FLOAT3 s = floor(p + dot(p, FLOAT3(F3, F3, F3)));
		 FLOAT3 x = p - s + dot(s, FLOAT3(G3, G3, G3));
	 
		 /* calculate i1 and i2 */
		 FLOAT3 e = step(FLOAT3(0.0, 0.0, 0.0), x - x.yzx);
		 FLOAT3 i1 = e*(1.0 - e.zxy);
		 FLOAT3 i2 = 1.0 - e.zxy*(1.0 - e);
	 	
		 /* x1, x2, x3 */
		 FLOAT3 x1 = x - i1 + G3;
		 FLOAT3 x2 = x - i2 + 2.0*G3;
		 FLOAT3 x3 = x - 1.0 + 3.0*G3;
	 
		 /* 2. find four surflets and store them in d */
		 FLOAT4 w, d;
	 
		 /* calculate surflet weights */
		 w.x = dot(x, x);
		 w.y = dot(x1, x1);
		 w.z = dot(x2, x2);
		 w.w = dot(x3, x3);
	 
		 /* w fades from 0.6 at the center of the surflet to 0.0 at the margin */
		 w = max(0.6 - w, 0.0);
	 
		 /* calculate surflet components */
		 d.x = dot(random3(s), x);
		 d.y = dot(random3(s + i1), x1);
		 d.z = dot(random3(s + i2), x2);
		 d.w = dot(random3(s + 1.0), x3);
	 
		 /* multiply d by w^4 */
		 w *= w;
		 w *= w;
		 d *= w;
	 
		 /* 3. return the sum of the four surflets */
		 return dot(d, FLOAT4(52.0, 52.0, 52.0, 52.0));
	}

	float classic_simplex2D(FLOAT2 p) {
		return classic_simplex3D(FLOAT3(p.x, p.y, 0.0));
	}

	float classic_simplex2D_fbm(FLOAT2 p){
		float s = 0.0;
		float m = 0.0;
		float a = 0.5;
		float f = 1.0;
	
		for( int i=0; i<OCTAVES; i++ ){
			s += a * classic_simplex2D(p * f);
			m += a;
			f *= LACUNARITY;
			a *= GAIN;
		}
		return s/m;
	}

	float classic_simplex3D_fbm(FLOAT3 p){
		float s = 0.0;
		float m = 0.0;
		float a = 0.5;
		float f = 1.0;
	
		for( int i=0; i<OCTAVES; i++ ){
			s += a * classic_simplex3D(p * f);
			m += a;
			f *= LACUNARITY;
			a *= GAIN;
		}
		return s/m;
	}
    #define SIMPLEX
#endif