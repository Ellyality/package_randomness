#if !defined(VORONOI)
	#if !defined(RANDOMNESS)
		#include "./randomness.cginc"
	#endif

	#if !defined(OCTAVES)
		#define OCTAVES 2
	#endif

	#define SWITCH_TIME 60.0

	FLOAT2 hash2D( FLOAT2 p ){
		p = FLOAT2( dot(p,FLOAT2(127.1,311.7)),dot(p,FLOAT2(269.5,183.3)));
		return FRACT(sin(p)*43758.5453);
	}

	float voronoi(FLOAT2 x, float time){
		FLOAT2 n = floor( x );
		FLOAT2 f = FRACT( x );
		float t = time/SWITCH_TIME;
	
		float F1 = 8.0;
		float F2 = 8.0;
	
		[unroll]
		for( int j=-1; j<=1; j++ )
			[unroll]
			for( int i=-1; i<=1; i++ ){
				FLOAT2 g = FLOAT2(i,j);
				FLOAT2 o = hash2D( n + g );

				o = 0.5 + 0.41*sin( time + 6.2831*o );	
				FLOAT2 r = g - f + o;

			float d = MOD(t/16.0,4.0) < 1.0 ? dot(r,r)  :				// euclidean^2
				  		MOD(t/16.0,4.0) < 2.0 ? sqrt(dot(r,r)) :			// euclidean
						MOD(t/16.0,4.0) < 3.0 ? abs(r.x) + abs(r.y) :		// manhattan
						MOD(t/16.0,4.0) < 4.0 ? max(abs(r.x), abs(r.y)) :	// chebyshev
						0.0;

			if( d<F1 ) { 
				F2 = F1; 
				F1 = d; 
			} else if( d<F2 ) {
				F2 = d;
			}
		}
	
		float c = MOD(t, 4.0) < 1.0 ? F1 : 
				  MOD(t, 4.0) < 2.0 ? F2 : 
				  MOD(t, 4.0) < 3.0 ? F2-F1 :
				  MOD(t, 4.0) < 4.0 ? (F1+F2)/2.0 : 
				  0.0;
		
		if( MOD(t, 8.0) >= 4.0)	c *= F1;
		if( MOD(t, 16.0) >= 8.0 )			c = 1.0 - c;
	
		return c;
	}
	
	float voronoi_fbm(FLOAT2 p, float time){
		float s = 0.0;
		float m = 0.0;
		float a = 0.5;
		float f = 1.0;
	
		for( int i=0; i<OCTAVES; i++ ){
			s += a * voronoi(p * f, time);
			m += a;
			f *= LACUNARITY;
			a *= GAIN;
		}
		return s/m;
	}
    #define VORONOI
#endif