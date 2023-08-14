using UnityEngine;
using UnityEngine.UI;

namespace Ellyality.Randomness
{
    [AddComponentMenu("Ellyality/Randomness/Curl 2D")]
    [RequireComponent(typeof(Image))]
    public class Curl : MonoBehaviour
    {
        [SerializeField] Texture2D StartPoint;
        [SerializeField][Range(1, 500)] float Dim = 50;
        [SerializeField] float Seed = 5781.127852f;
        [SerializeField] bool UseTime = false;
        [SerializeField] float FlowSpeed = 1.5f;
        [SerializeField] float Speed = 1.0f;
        [SerializeField] float NoiseMultiplier = 0.1f;
        [SerializeField][Range(1, 7)] int OCTAVES = 1;

        ComputeShader passone_shader;
        ComputeShader passtwo_shader;
        RenderTexture passone_rt;
        RenderTexture passtwo_rt;
        NoiseGen passone_gen;
        NoiseGen passtwo_gen;
        Image image;
        Material material;
        float passTime;

        private void Start()
        {
            image = GetComponent<Image>();
            image.material = new Material(Shader.Find("Unlit/Texture"));
            material = image.material;
            PassOneInit();
            PassTwoInit();
            passone_gen.RunShader();
        }

        void PassOneInit()
        {
            passone_shader = Resources.Load<ComputeShader>("Randomness/Curl");
            NoiseGenBuilder Builder = new NoiseGenBuilder(gameObject);
            Builder.SetShader(passone_shader);
            Builder.SetSize(StartPoint.width, StartPoint.height);
            passone_gen = Builder.Build();
            passone_rt = passone_gen.output;
            passone_rt.wrapMode = TextureWrapMode.Repeat;
            passone_gen.RegisterFinishCallback(PassOneFinish);
            passone_gen.RegisterPreloadCallback(PassOnePreload);
        }

        void PassTwoInit()
        {
            passtwo_shader = Resources.Load<ComputeShader>("Randomness/Curl2");
            NoiseGenBuilder Builder = new NoiseGenBuilder(gameObject);
            Builder.SetShader(passtwo_shader);
            Builder.SetSize(StartPoint.width, StartPoint.height);
            passtwo_gen = Builder.Build();
            passtwo_rt = passtwo_gen.output;
            passtwo_rt.wrapMode = TextureWrapMode.Repeat;
            Graphics.Blit(StartPoint, passtwo_rt);
            passtwo_gen.RegisterFinishCallback(PassTwoFinish);
            passtwo_gen.RegisterPreloadCallback(PassTwoPreload);
            material.mainTexture = passtwo_gen.output;
        }

        void PassOnePreload(ComputeShader shader)
        {
            shader.SetFloat("_Dim", Dim);
            shader.SetFloat("_SEED", Seed);
            shader.SetFloat("_Time", Time.time * Speed);
            shader.SetFloat("_NoiseMultipler", NoiseMultiplier);
            shader.SetInt("_OCTAVES", OCTAVES);
        }

        void PassOneFinish(RenderTexture rt)
        {
            passtwo_gen.RunShader();
        }

        void PassTwoPreload(ComputeShader shader)
        {
            int kernal = shader.FindKernel("CSMain");
            shader.SetTexture(kernal, "Noise", passone_rt);
            shader.SetFloat("FlowSpeed", FlowSpeed);
        }

        void PassTwoFinish(RenderTexture rt)
        {
            material.mainTexture = rt;
            passone_gen.RunShader();
        }
    }
}
