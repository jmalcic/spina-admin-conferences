import resolve from 'rollup-plugin-node-resolve'
import babel from 'rollup-plugin-babel'
import { uglify } from 'rollup-plugin-uglify'
import postcss from 'rollup-plugin-postcss'

const uglifyOptions = {
  mangle: false,
  compress: false,
  output: {
    beautify: true,
    indent_level: 2
  }
}

const postcssOptions = {
  extract: true
}

export default [{
  input: 'app/javascript/spina/admin/conferences',
  output: {
    file: 'app/assets/javascripts/spina/admin/conferences/application.js',
    format: 'umd',
    name: 'Spina::Admin::Conferences'
  },
  plugins: [
    resolve(),
    babel(),
    uglify(uglifyOptions)
  ]
}, {
  input: 'app/javascript/conference',
  output: {
    file: 'app/assets/javascripts/conference/application.js',
    format: 'umd',
    name: 'Conference'
  },
  plugins: [
    resolve(),
    babel(),
    uglify(uglifyOptions)
  ]
}, {
  input: 'app/javascript/conference/styles/application.sass',
  output: {
    file: 'app/assets/stylesheets/conference/application.css',
    format: 'umd',
    name: 'Conference'
  },
  plugins: [
    postcss(postcssOptions)
  ]
}]
