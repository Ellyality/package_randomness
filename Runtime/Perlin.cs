using UnityEngine;
using UnityEngine.UI;

namespace Ellyality.Randomness
{
    [AddComponentMenu("Ellyality/Randomness/Perlin 2D")]
    [RequireComponent(typeof(Image))]
    [ExecuteAlways]
    public class Perlin : NoiseBase<Image>
    {
        [SerializeField][Range(1, 500)] float Dim = 50;
        [SerializeField] float Seed = 5781.127852f;

        void Start()
        {
            Init("Ellyality/Perlin2D");
            UpdateValue();
        }

        public override void UpdateValue()
        {
            if (!material) return;
            material.SetFloat("_Dim", Dim);
            material.SetFloat("_Seed", Seed);
            Debug.Log(material.GetFloat("_Seed"));
        }
    }
}