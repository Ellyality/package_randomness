using UnityEngine;
using UnityEngine.UI;

namespace Ellyality.Randomness
{
    [AddComponentMenu("Ellyality/Randomness/Voronoi 2D")]
    [RequireComponent(typeof(Image))]
    [ExecuteAlways]
    public class Voronoi : NoiseBase<Image>
    {
        [SerializeField][Range(1, 500)] float Dim = 50;
        [SerializeField] float Seed = 5781.127852f;
        [SerializeField] bool UseTime = false;
        [SerializeField] float Speed = 1.0f;
        [SerializeField][Range(1, 7)] int OCTAVES = 1;

        void OnEnable()
        {
            Init("Ellyality/Voronoi2D");
            UpdateValue();
        }

        public override void UpdateValue()
        {
            if (!material) return;
            material.SetFloat("_Dim", Dim);
            material.SetFloat("_Seed", Seed);
            if(UseTime) 
                material.EnableKeyword("USETIME");
            else
                material.DisableKeyword("USETIME");
            material.SetFloat("_Speed", Speed);
            material.SetInteger("_OCTAVES", OCTAVES);
        }
    }
}
