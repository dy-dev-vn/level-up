import react from '@vitejs/plugin-react'
import inertia from '@inertiajs/vite'
import tailwindcss from '@tailwindcss/vite'
import { defineConfig } from 'vite'
import { fileURLToPath } from 'node:url'
import { resolve } from 'node:path'
import RubyPlugin from 'vite-plugin-ruby'

export default defineConfig({
  plugins: [
    tailwindcss(),
    RubyPlugin(),
    inertia(),
    react(),
  ],
  resolve: { alias: { '@': resolve(fileURLToPath(new URL('.', import.meta.url)), 'app/frontend') } },
})
