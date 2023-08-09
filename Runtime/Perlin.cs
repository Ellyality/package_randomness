using UnityEngine;
using UnityEngine.UI;

namespace Ellyality.Randomness
{
    [AddComponentMenu("Ellyality/Randomness/Perlin 2D")]
    [RequireComponent(typeof(Image))]
    [ExecuteAlways]
    public class Perlin : MonoBehaviour
    {
        Image image;
        Shader shader;
        Material material;

        void Start()
        {
            shader = Shader.Find("Ellyality/Perlin2D");
            image = GetComponent<Image>();
            material = new Material(shader);
            image.material = material;
        }

        void OnValidate()
        {
            
        }
    }
}