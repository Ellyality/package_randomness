using UnityEngine;
using UnityEngine.UI;

namespace Ellyality.Randomness
{
    [AddComponentMenu("Ellyality/Randomness/Simplex 2D")]
    [RequireComponent(typeof(Image))]
    [ExecuteAlways]
    public class Simplex : NoiseBase<Image>
    {
        [SerializeField][Range(1, 500)] float Dim = 50;
        [SerializeField] float Seed = 5781.127852f;

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
        }
    }
}
