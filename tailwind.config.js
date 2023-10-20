module.exports = {
  theme: {
    extend: {},
  },
  variants: {},
  content: [
    './app/views/**/*.html.erb',
    './app/views/**/*.html.haml',
    './app/helpers/**/*.rb',
    './app/assets/javascript/**/*.css',
    './app/javascript/**/*.js'
  ],
  plugins: [
    require("@tailwindcss/typography"),
    require("@tailwindcss/forms"),
    require("daisyui")
  ]
}
