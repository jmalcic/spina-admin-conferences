import resolve from 'rollup-plugin-node-resolve'
import babel from 'rollup-plugin-babel'
import { uglify } from 'rollup-plugin-uglify'

const uglifyOptions = {
  mangle: false,
  compress: false,
  output: {
    beautify: true,
    indent_level: 2
  }
}

export default [{
  input: 'app/javascript/spina/admin/conferences/application',
  output: {
    file: 'app/assets/javascripts/spina/admin/conferences/application.es6',
    format: 'esm',
    name: 'Spina::Admin::Conferences'
  },
  plugins: [
    resolve(),
    babel(),
    uglify(uglifyOptions)
  ]
}, {
  input: 'app/javascript/conference/application',
  output: {
    file: 'app/assets/javascripts/conference/application.es6',
    format: 'esm',
    name: 'Conference'
  },
  plugins: [
    resolve(),
    babel(),
    uglify(uglifyOptions)
  ]
}]
