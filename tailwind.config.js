module.exports = {
  theme: {
    extend: {},
  },
  variants: {},
  content: [
    './app/views/**/*.{erb,haml,turbo_stream}',
    './app/components/**/*.{erb,haml,rb}',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.{js,css}'
  ],
  plugins: [
    require("@tailwindcss/typography"),
    require("@tailwindcss/forms"),
    require("daisyui")
  ],
  daisyui: {
    themes: [
      'light',
      'dark'
    ]
  }
}
