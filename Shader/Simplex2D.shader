Shader "Ellyality/Simplex2D"
{
    Properties
    {
        [PerRendererData] _MainTex ("Texture", 2D) = "white" {}
        _Dim ("DIM", Range(1, 500)) = 100
        _SEED ("SEED", FLOAT) = 5781.127852
        _Speed ("_SPEED", FLOAT) = 1.0
        [TOGGLE(USETIME)] _USETIME ("Use Time", FLOAT) = 0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float4 _MainTex_TexelSize;
            float _Dim;
            float _SEED;
            float _Speed;
            #define SEED _SEED

            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog
            #pragma multi_compile __ USETIME

            #include "UnityCG.cginc"
            #include "./simplex.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
#if USETIME
                fixed4 col = classic_simplex3D(FLOAT3(i.uv.x, i.uv.y, _Time.x * _Speed) * _Dim);
#else
                fixed4 col = classic_simplex3D(FLOAT3(i.uv.x, i.uv.y, 0.0) * _Dim);
#endif

                col.a = 1.0;
                col = col * 0.5 + 0.5;
                UNITY_APPLY_FOG(i.fogCoord, col);
                return pow(col, 2.2 / 1.0);
            }
            ENDCG
        }
    }
}
