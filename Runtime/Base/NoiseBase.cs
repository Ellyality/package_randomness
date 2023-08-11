using UnityEngine;
using UnityEngine.UI;

namespace Ellyality.Randomness
{
    public abstract class NoiseBase<T> : MonoBehaviour where T : MaskableGraphic
    {
        protected T image { private set; get; }
        protected Shader shader { private set; get; }
        protected Material material { private set; get; }

        // Start is called before the first frame update
        protected void Init(string shaderKeyword)
        {
            shader = Shader.Find(shaderKeyword);
            image = GetComponent<T>();
            material = new Material(shader);
            image.material = material;
        }

        public abstract void UpdateValue();

        void OnValidate()
        {
            UpdateValue();
        }
    }
}
