import { defineConfig } from 'vite'
import tailwindcss from '@tailwindcss/vite'
import RubyPlugin from 'vite-plugin-ruby'
import StimulusHMR from "vite-plugin-stimulus-hmr";
import FullReload from "vite-plugin-full-reload";

const viteRubyPorts: Record<string, number> = {
  development: 3036,
  test: 3037,
}

export default defineConfig(({ mode }) => ({
  server: {
    hmr: true,
    ws: {
      clientPort: viteRubyPorts[mode],
    },
  },
  plugins: [
    tailwindcss(),
    RubyPlugin(),
    StimulusHMR(),
    // You can specify any paths you want to watch for changes
    FullReload(["app/views/**/*.haml", "app/views/**/*.erb"])
  ],
}))
