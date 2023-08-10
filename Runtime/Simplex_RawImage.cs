using UnityEngine;
using UnityEngine.UI;

namespace Ellyality.Randomness
{
    [AddComponentMenu("Ellyality/Randomness/Simplex 2D RawImage")]
    [RequireComponent(typeof(RawImage))]
    [ExecuteAlways]
    public class Simplex_RawImage : NoiseBase<RawImage>
    {
        [SerializeField][Range(1, 500)] float Dim = 50;
        [SerializeField] float Seed = 5781.127852f;
        [SerializeField] bool UseTime = false;
        [SerializeField] float Speed = 1.0f;

        void Start()
        {
            Init("Ellyality/Simplex2D");
            UpdateValue();
        }

        public override void UpdateValue()
        {
            if (!material) return;
            material.SetFloat("_Dim", Dim);
            material.SetFloat("_Seed", Seed);
            if (UseTime)
                material.EnableKeyword("USETIME");
            else
                material.DisableKeyword("USETIME");
            material.SetFloat("_Speed", Speed);
        }
    }
}
