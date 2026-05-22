module.exports = {
  theme: {
    extend: {},
  },
  content: [
    './app/views/**/*.{erb,haml,turbo_stream}',
    './app/components/**/*.{erb,haml,rb}',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.{js,css}'
  ]
}
