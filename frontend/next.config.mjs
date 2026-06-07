const internalApiUrl = process.env.INTERNAL_API_URL || "http://localhost:8000";

/** @type {import('next').NextConfig} */
const nextConfig = {
  // Tremor v3 requires transpilation in Next.js 14 App Router
  transpilePackages: ["@tremor/react"],
  async rewrites() {
    return [
      {
        source: "/api/:path*",
        destination: `${internalApiUrl.replace(/\/$/, "")}/api/:path*`,
      },
    ];
  },
};

export default nextConfig;
