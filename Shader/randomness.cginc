#if !defined(RANDOMNESS)
	#if defined (SHADERLAB_GLSL)
		#define INLINE
		#define INT2 ivec2
		#define INT3 ivec3
		#define INT4 ivec4
		#define HALF float
		#define HALF2 vec2
		#define HALF3 vec3
		#define HALF4 vec4
		#define FLOAT2 vec2
		#define FLOAT3 vec3
		#define FLOAT4 vec4
		#define FIXED2 vec2
		#define FIXED4 vec4
		#define FLOAT3X3 mat3
		#define FLOAT4X4 mat4
		#define LERP mix
		#define FRACT fract
		#define MOD mod
	#else
		#define INLINE inline
		#define INT2 int2
		#define INT3 int3
		#define INT4 int4
		#define HALF half
		#define HALF2 half2
		#define HALF3 half3
		#define HALF4 half4
		#define FLOAT2 float2
		#define FLOAT3 float3
		#define FLOAT4 float4
		#define FIXED2 fixed2
		#define FIXED4 fixed4
		#define FLOAT3X3 float3x3
		#define FLOAT4X4 float4x4
		#define LERP lerp
		#define FRACT frac
		#define MOD fmod
	#endif
	
	#if !defined(SEED)
		#define SEED 43758.5453123
	#endif

	float rand(float n) { return FRACT(sin(n) * SEED); }
	float rand(FLOAT2 n) { return FRACT(sin(dot(n, FLOAT2(12.9898, 4.1414))) * SEED); }
	float hash(float n) { return FRACT(sin(n) * 1e4); }
	float hash(FLOAT2 p) { return FRACT(1e4 * sin(17.0 * p.x + p.y * 0.1) * (0.1 + abs(sin(p.y * 13.0 + p.x)))); }
	float mod289(float x){return x - floor(x * (1.0 / 289.0)) * 289.0;}
	FLOAT4 mod289(FLOAT4 x){return x - floor(x * (1.0 / 289.0)) * 289.0;}
	FLOAT4 perm(FLOAT4 x){return mod289(((x * 34.0) + 1.0) * x);}

	float noise(float p){
		float fl = floor(p);
	  float fc = FRACT(p);
		return LERP(rand(fl), rand(fl + 1.0), fc);
	}

	float noise_v2(float x) {
		float i = floor(x);
		float f = FRACT(x);
		float u = f * f * (3.0 - 2.0 * f);
		return LERP(hash(i), hash(i + 1.0), u);
	}

	float noise(FLOAT2 n) {
		const FLOAT2 d = FLOAT2(0.0, 1.0);
		FLOAT2 b = floor(n), f = smoothstep(FLOAT2(0.0, 0.0), FLOAT2(1.0, 1.0), FRACT(n));
		return LERP(LERP(rand(b), rand(b + d.yx), f.x), LERP(rand(b + d.xy), rand(b + d.yy), f.x), f.y);
	}

	float noise_v2(FLOAT2 p){
		FLOAT2 ip = floor(p);
		FLOAT2 u = FRACT(p);
		u = u*u*(3.0-2.0*u);
	
		float res = LERP(
			LERP(rand(ip),rand(ip+FLOAT2(1.0,0.0)),u.x),
			LERP(rand(ip+FLOAT2(0.0,1.0)),rand(ip+FLOAT2(1.0,1.0)),u.x),u.y);
		return res*res;
	}

	float noise_v3(FLOAT2 x) {
		FLOAT2 i = floor(x);
		FLOAT2 f = FRACT(x);

		// Four corners in 2D of a tile
		float a = hash(i);
		float b = hash(i + FLOAT2(1.0, 0.0));
		float c = hash(i + FLOAT2(0.0, 1.0));
		float d = hash(i + FLOAT2(1.0, 1.0));

		// Simple 2D lerp using smoothstep envelope between the values.
		// return vec3(LERP(LERP(a, b, smoothstep(0.0, 1.0, f.x)),
		//			LERP(c, d, smoothstep(0.0, 1.0, f.x)),
		//			smoothstep(0.0, 1.0, f.y)));

		// Same code, with the clamps in smoothstep and common subexpressions
		// optimized away.
		FLOAT2 u = f * f * (3.0 - 2.0 * f);
		return LERP(a, b, u.x) + (c - a) * u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
	}

	float noise(FLOAT3 p){
		FLOAT3 a = floor(p);
		FLOAT3 d = p - a;
		d = d * d * (3.0 - 2.0 * d);

		FLOAT4 b = a.xxyy + FLOAT4(0.0, 1.0, 0.0, 1.0);
		FLOAT4 k1 = perm(b.xyxy);
		FLOAT4 k2 = perm(k1.xyxy + b.zzww);

		FLOAT4 c = k2 + a.zzzz;
		FLOAT4 k3 = perm(c);
		FLOAT4 k4 = perm(c + 1.0);

		FLOAT4 o1 = FRACT(k3 * (1.0 / 41.0));
		FLOAT4 o2 = FRACT(k4 * (1.0 / 41.0));

		FLOAT4 o3 = o2 * d.z + o1 * (1.0 - d.z);
		FLOAT2 o4 = o3.yw * d.x + o3.xz * (1.0 - d.x);

		return o4.y * d.y + o4.x * (1.0 - d.y);
	}

	float noise_v2(FLOAT3 x) {
		const FLOAT3 step = FLOAT3(110, 241, 171);

		FLOAT3 i = floor(x);
		FLOAT3 f = FRACT(x);
 
		// For performance, compute the base input to a 1D hash from the integer part of the argument and the 
		// incremental change to the 1D based on the 3D -> 1D wrapping
		float n = dot(i, step);

		FLOAT3 u = f * f * (3.0 - 2.0 * f);
		return LERP(LERP(LERP( hash(n + dot(step, FLOAT3(0, 0, 0))), hash(n + dot(step, FLOAT3(1, 0, 0))), u.x),
					   LERP( hash(n + dot(step, FLOAT3(0, 1, 0))), hash(n + dot(step, FLOAT3(1, 1, 0))), u.x), u.y),
				   LERP(LERP( hash(n + dot(step, FLOAT3(0, 0, 1))), hash(n + dot(step, FLOAT3(1, 0, 1))), u.x),
					   LERP( hash(n + dot(step, FLOAT3(0, 1, 1))), hash(n + dot(step, FLOAT3(1, 1, 1))), u.x), u.y), u.z);
	}
#define RANDOMNESS
#endif