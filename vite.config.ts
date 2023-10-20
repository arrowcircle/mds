import { defineConfig } from 'vite'
import RubyPlugin from 'vite-plugin-ruby'
import StimulusHMR from "vite-plugin-stimulus-hmr";
import FullReload from "vite-plugin-full-reload";

export default defineConfig({
  plugins: [
    RubyPlugin(),
    StimulusHMR(),
    // You can specify any paths you want to watch for changes
    FullReload(["app/views/**/*.haml", "app/views/**/*.erb"])
  ],
})
