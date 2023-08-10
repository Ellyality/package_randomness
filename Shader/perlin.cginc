
#if !defined(PERLIN)
	#if !defined(RANDOMNESS)
		#include "./randomness.cginc"
	#endif

	#define M_PI 3.14159265358979323846
	float rand_perlin(FLOAT2 co){return FRACT(sin(dot(co.xy ,FLOAT2(12.9898,78.233))) * SEED);}
	float rand_p2 (FLOAT2 co, float l) {return rand_perlin(FLOAT2(rand(co), l));}
	float rand_p2 (FLOAT2 co, float l, float t) {return rand_perlin(FLOAT2(rand_p2(co, l), t));}
	FLOAT2 fade(FLOAT2 t) {return t*t*t*(t*(t*6.0-15.0)+10.0);}
	FLOAT4 permute(FLOAT4 x){return MOD(((x*34.0)+1.0)*x, SEED);}
	FLOAT4 taylorInvSqrt(FLOAT4 r){return 1.79284291400159 - 0.85373472095314 * r;}
	FLOAT3 fade(FLOAT3 t) {return t*t*t*(t*(t*6.0-15.0)+10.0);}

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
		return perlin(p, dim, 0.0);
	}

	float classic_perlin2D(FLOAT2 P){
		FLOAT4 Pi = floor(P.xyxy) + FLOAT4(0.0, 0.0, 1.0, 1.0);
		FLOAT4 Pf = FRACT(P.xyxy) - FLOAT4(0.0, 0.0, 1.0, 1.0);
		Pi = MOD(Pi, 289.0); // To avoid truncation effects in permutation
		FLOAT4 ix = Pi.xzxz;
		FLOAT4 iy = Pi.yyww;
		FLOAT4 fx = Pf.xzxz;
		FLOAT4 fy = Pf.yyww;
		FLOAT4 i = permute(permute(ix) + iy);
		FLOAT4 gx = 2.0 * FRACT(i * 0.0243902439) - 1.0; // 1/41 = 0.024...
		FLOAT4 gy = abs(gx) - 0.5;
		FLOAT4 tx = floor(gx + 0.5);
		gx = gx - tx;
		FLOAT2 g00 = FLOAT2(gx.x,gy.x);
		FLOAT2 g10 = FLOAT2(gx.y,gy.y);
		FLOAT2 g01 = FLOAT2(gx.z,gy.z);
		FLOAT2 g11 = FLOAT2(gx.w,gy.w);
		FLOAT4 norm = 1.79284291400159 - 0.85373472095314 * 
			FLOAT4(dot(g00, g00), dot(g01, g01), dot(g10, g10), dot(g11, g11));
		g00 *= norm.x;
		g01 *= norm.y;
		g10 *= norm.z;
		g11 *= norm.w;
		float n00 = dot(g00, FLOAT2(fx.x, fy.x));
		float n10 = dot(g10, FLOAT2(fx.y, fy.y));
		float n01 = dot(g01, FLOAT2(fx.z, fy.z));
		float n11 = dot(g11, FLOAT2(fx.w, fy.w));
		FLOAT2 fade_xy = fade(Pf.xy);
		FLOAT2 n_x = LERP(FLOAT2(n00, n01), FLOAT2(n10, n11), fade_xy.x);
		float n_xy = LERP(n_x.x, n_x.y, fade_xy.y);
		return 2.3 * n_xy;
	}

	float classic_perlin3D(FLOAT3 P){
		FLOAT3 Pi0 = floor(P); // Integer part for indexing
		FLOAT3 Pi1 = Pi0 + FLOAT3(1.0, 1.0, 1.0); // Integer part + 1
		Pi0 = MOD(Pi0, 289.0);
		Pi1 = MOD(Pi1, 289.0);
		FLOAT3 Pf0 = FRACT(P); // Fractional part for interpolation
		FLOAT3 Pf1 = Pf0 - FLOAT3(1.0, 1.0, 1.0); // Fractional part - 1.0
		FLOAT4 ix = FLOAT4(Pi0.x, Pi1.x, Pi0.x, Pi1.x);
		FLOAT4 iy = FLOAT4(Pi0.yy, Pi1.yy);
		FLOAT4 iz0 = Pi0.zzzz;
		FLOAT4 iz1 = Pi1.zzzz;

		FLOAT4 ixy = permute(permute(ix) + iy);
		FLOAT4 ixy0 = permute(ixy + iz0);
		FLOAT4 ixy1 = permute(ixy + iz1);

		FLOAT4 gx0 = ixy0 / 7.0;
		FLOAT4 gy0 = FRACT(floor(gx0) / 7.0) - 0.5;
		gx0 = FRACT(gx0);
		FLOAT4 gz0 = FLOAT4(0.5, 0.5, 0.5, 0.5) - abs(gx0) - abs(gy0);
		FLOAT4 sz0 = step(gz0, FLOAT4(0.0, 0.0, 0.0, 0.0));
		gx0 -= sz0 * (step(0.0, gx0) - 0.5);
		gy0 -= sz0 * (step(0.0, gy0) - 0.5);

		FLOAT4 gx1 = ixy1 / 7.0;
		FLOAT4 gy1 = FRACT(floor(gx1) / 7.0) - 0.5;
		gx1 = FRACT(gx1);
		FLOAT4 gz1 = FLOAT4(0.5, 0.5, 0.5, 0.5) - abs(gx1) - abs(gy1);
		FLOAT4 sz1 = step(gz1, FLOAT4(0.0, 0.0, 0.0, 0.0));
		gx1 -= sz1 * (step(0.0, gx1) - 0.5);
		gy1 -= sz1 * (step(0.0, gy1) - 0.5);

		FLOAT3 g000 = FLOAT3(gx0.x,gy0.x,gz0.x);
		FLOAT3 g100 = FLOAT3(gx0.y,gy0.y,gz0.y);
		FLOAT3 g010 = FLOAT3(gx0.z,gy0.z,gz0.z);
		FLOAT3 g110 = FLOAT3(gx0.w,gy0.w,gz0.w);
		FLOAT3 g001 = FLOAT3(gx1.x,gy1.x,gz1.x);
		FLOAT3 g101 = FLOAT3(gx1.y,gy1.y,gz1.y);
		FLOAT3 g011 = FLOAT3(gx1.z,gy1.z,gz1.z);
		FLOAT3 g111 = FLOAT3(gx1.w,gy1.w,gz1.w);

		FLOAT4 norm0 = taylorInvSqrt(FLOAT4(dot(g000, g000), dot(g010, g010), dot(g100, g100), dot(g110, g110)));
		g000 *= norm0.x;
		g010 *= norm0.y;
		g100 *= norm0.z;
		g110 *= norm0.w;
		FLOAT4 norm1 = taylorInvSqrt(FLOAT4(dot(g001, g001), dot(g011, g011), dot(g101, g101), dot(g111, g111)));
		g001 *= norm1.x;
		g011 *= norm1.y;
		g101 *= norm1.z;
		g111 *= norm1.w;

		float n000 = dot(g000, Pf0);
		float n100 = dot(g100, FLOAT3(Pf1.x, Pf0.yz));
		float n010 = dot(g010, FLOAT3(Pf0.x, Pf1.y, Pf0.z));
		float n110 = dot(g110, FLOAT3(Pf1.xy, Pf0.z));
		float n001 = dot(g001, FLOAT3(Pf0.xy, Pf1.z));
		float n101 = dot(g101, FLOAT3(Pf1.x, Pf0.y, Pf1.z));
		float n011 = dot(g011, FLOAT3(Pf0.x, Pf1.yz));
		float n111 = dot(g111, Pf1);

		FLOAT3 fade_xyz = fade(Pf0);
		FLOAT4 n_z = LERP(FLOAT4(n000, n100, n010, n110), FLOAT4(n001, n101, n011, n111), fade_xyz.z);
		FLOAT2 n_yz = LERP(n_z.xy, n_z.zw, fade_xyz.y);
		float n_xyz = LERP(n_yz.x, n_yz.y, fade_xyz.x); 
		return 2.2 * n_xyz;
	}

	float classic_perlin2D_fbm(FLOAT2 p){
		float s = 0.0;
		float m = 0.0;
		float a = 0.5;
	
		for( int i=0; i<OCTAVES; i++ ){
			s += a * classic_perlin2D(p);
			m += a;
			a *= 0.5;
			p *= 2.0;
		}
		return s/m;
	}

	#define PERLIN
#endif