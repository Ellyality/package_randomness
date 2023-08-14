using Codice.CM.Common;
using UnityEngine;

namespace Ellyality.Randomness
{
    [AddComponentMenu("Ellyality/Randomness/Terrain Noise")]
    [RequireComponent(typeof(Terrain))]
    public class TerrainHeightNoise : MonoBehaviour
    {
        enum NoiseType
        {
            Noise,
            Perlin,
            Simplex
        }

        [SerializeField] NoiseType NType;
        [SerializeField] int Octave;
        [SerializeField] float Seed;
        [SerializeField] float Dim;

        Terrain terrain;

        private void Awake()
        {
            terrain = GetComponent<Terrain>();
        }

        private void Start()
        {
            
            NoiseGenBuilder builder = new NoiseGenBuilder(gameObject);
            switch (NType)
            {
                case NoiseType.Noise:
                    builder.SetShader(Resources.Load<ComputeShader>("Randomness/Noise"));
                    break;
                case NoiseType.Perlin:
                    builder.SetShader(Resources.Load<ComputeShader>("Randomness/Perlin"));
                    break;
                case NoiseType.Simplex:
                    builder.SetShader(Resources.Load<ComputeShader>("Randomness/Simplex"));
                    break;
            }
            builder.SetSize(terrain.terrainData.heightmapResolution, terrain.terrainData.heightmapResolution);
            var gen = builder.Build();
            gen.RegisterFinishCallback(Finish);
            gen.RegisterPreloadCallback(Preload);
            gen.RunShader();
        }

        void Preload(ComputeShader sha)
        {
            sha.SetFloat("_Dim", Dim);
            sha.SetFloat("_SEED", Seed);
            sha.SetInt("_OCTAVES", Octave);
        }

        void Finish(RenderTexture tex)
        {
            RenderTexture.active = tex;
            terrain.terrainData.CopyActiveRenderTextureToHeightmap(
                new RectInt(0, 0, tex.width, tex.height),
                new Vector2Int(0, 0),
                TerrainHeightmapSyncControl.HeightOnly);
            RenderTexture.active = null;
        }
    }
}
