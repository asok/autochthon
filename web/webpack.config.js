module.exports = {
  entry: [
    'babel-core/polyfill',
    './src/main.jsx'
  ],

  output: {
    filename: 'bundle.js',
    path: '../public/',
    hash: true
  },

  module: {
    loaders: [
      { test: /\.jsx?$/, exclude: /node_modules/, loader: 'babel-loader' }
    ]
  },

  resolve: {
    extensions: ['', '.js', '.jsx']
  }
};
