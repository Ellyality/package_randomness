using System.Collections;
using UnityEngine;
using UnityEngine.Events;
using UnityEngine.Rendering;

namespace Ellyality.Randomness
{
    public class NoiseGen : MonoBehaviour
    {
        public ComputeShader shader { private set; get; }
        public RenderTexture output { private set; get; }
        public Vector3Int thread { private set; get; }
        readonly UnityEvent<RenderTexture> finish = new UnityEvent<RenderTexture>();
        readonly UnityEvent<ComputeShader> preload = new UnityEvent<ComputeShader>();

        internal void Register(NoiseGenBuilder builder)
        {
            shader = builder.shader;
            thread = builder.thread;
            output = new RenderTexture(builder.size.x, builder.size.y, builder.size.z);
            output.enableRandomWrite = true;
            output.Create();
        }

        public void RegisterFinishCallback(UnityAction<RenderTexture> action) => finish.AddListener(action);
        public void RegisterPreloadCallback(UnityAction<ComputeShader> action) => preload.AddListener(action);
        public void ClearFinishCallback() => finish.RemoveAllListeners();
        public void ClearPreloadCallback() => preload.RemoveAllListeners();

        public void RunShader()
        {
            StartCoroutine(RunShaderInternal());
        }

        IEnumerator RunShaderInternal()
        {
            int kernelHandler = shader.FindKernel("CSMain");
            shader.SetTexture(kernelHandler, "Result", output);
            shader.SetInt("ResultWidth", output.width);
            shader.SetInt("ResultHeight", output.height);
            preload.Invoke(shader);
            shader.Dispatch(kernelHandler, output.width / thread.x, output.height / thread.y, 1);
            AsyncGPUReadbackRequest req = AsyncGPUReadback.Request(output);
            yield return new WaitUntil(() => req.done);
            finish.Invoke(output);
        }
    }
}
