using System;
using UnityEngine;

namespace Ellyality.Randomness
{
    public interface INoiseGenBuilder
    {
        void SetShader(ComputeShader shader);
        void SetSize(Vector2Int size);
        void SetSize(Vector2Int size, int depth);
        void SetSize(int width, int height);
        void SetSize(int width, int height, int depth);
        void SetThreadSize(Vector2Int size);
        void SetThreadSize(Vector3Int size);
        void SetThreadSize(int x, int y);
        void SetThreadSize(int x, int y, int z);
        void SetResult(RenderTexture rt);
        NoiseGen Build();
    }

    public sealed class NoiseGenBuilder : INoiseGenBuilder
    {
        internal Vector3Int thread;
        internal Vector3Int size;
        internal GameObject go;
        internal ComputeShader shader;
        internal RenderTexture rt;

        public NoiseGenBuilder(GameObject go)
        {
            this.go = go;
            size = new Vector3Int(256, 256, 24);
            thread = new Vector3Int(8, 8, 1);
        }

        public NoiseGen Build()
        {
            if (shader == null) throw new NullReferenceException("NoiseGenBuilder must register a shader");
            if (rt != null) size = new Vector3Int(rt.width, rt.height, rt.depth);
            NoiseGen ng = go.AddComponent<NoiseGen>();
            ng.Register(this);
            return ng;
        }

        public void SetResult(RenderTexture rt)
        {
            throw new NotImplementedException();
        }

        public void SetShader(ComputeShader shader)
        {
            this.shader = shader;
        }

        public void SetSize(Vector2Int size)
        {
            this.size.x = size.x;
            this.size.y = size.y;
        }

        public void SetSize(Vector2Int size, int depth)
        {
            this.size.x = size.x;
            this.size.y = size.y;
            this.size.z = depth;
        }

        public void SetSize(int width, int height)
        {
            this.size.x = width;
            this.size.y = height;
        }

        public void SetSize(int width, int height, int depth)
        {
            this.size.x = width;
            this.size.y = height;
            this.size.z = depth;
        }

        public void SetThreadSize(Vector2Int size)
        {
            thread.x = size.x;
            thread.y = size.y;
        }

        public void SetThreadSize(Vector3Int size)
        {
            thread.x = size.x;
            thread.y = size.y;
            thread.z = size.z;
        }

        public void SetThreadSize(int x, int y)
        {
            thread.x = x;
            thread.y = y;
        }

        public void SetThreadSize(int x, int y, int z)
        {
            thread.x = x;
            thread.y = y;
            thread.z = z;
        }
    }
}
