Shader "Ellyality/Normal Noise" {
Properties {
    _MainTex ("Base (RGB)", 2D) = "white" {}
    _Dim ("DIM", Range(1, 500)) = 100
    _SEED ("SEED", FLOAT) = 5781.127852
    _Speed ("_SPEED", FLOAT) = 1.0
    [Toggle(USETIME)] _USETIME ("Use Time", FLOAT) = 0
}

SubShader {
    Tags { "RenderType"="Opaque" }
    LOD 250

CGPROGRAM
#pragma surface surf Lambert noforwardadd

sampler2D _MainTex;
sampler2D _BumpMap;
float _Dim;
float _SEED;
float _Speed;
#define SEED _SEED
#pragma multi_compile __ USETIME

#include "./normal.cginc"

struct Input {
    float2 uv_MainTex;
};

void surf (Input IN, inout SurfaceOutput o) {
#if USETIME
    float3 nor = normalNoise(IN.uv_MainTex * _Dim, 1.0, _Speed, _Time.x);
#else
    float3 nor = normalNoise(IN.uv_MainTex * _Dim, 1.0, _Speed, 0.0);
#endif
    fixed4 c = tex2D(_MainTex, IN.uv_MainTex);
    o.Albedo = c.rgb;
    o.Alpha = c.a;
    o.Normal = UnpackNormal(fixed4(nor, 1.0));
}
ENDCG
}

FallBack "Mobile/Diffuse"
}
