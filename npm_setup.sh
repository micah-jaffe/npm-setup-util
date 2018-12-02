#!/usr/bin/env sh

echo "Starting NPM setup..."

# NB: This file must be run in main project directory to interpret file names!
project_name=${PWD##*/}

npm init -y

cat << EOF > package.json
{
    "name": "$project_name",
    "version": "1.0.0",
    "description": "Your project description here...",
    "main": "frontend/$project_name.jsx",
    "scripts": {
        "test": "echo \"Error: no test specified\" && exit 1",
        "webpack": "webpack --mode=development --watch"
    },
    "keywords": [],
    "author": "",
    "license": "ISC"
}
EOF

npm install webpack
npm install webpack-cli --save-dev
npm install @babel/core
npm install @babel/preset-env
npm install @babel/preset-react
npm install babel-loader
npm install react
npm install react-dom

cat << EOF > index.html
<!DOCTYPE html>
<html>
    <head>
	    <title></title>
	    <script src="./dist/bundle.js"></script>
    </head>
    <body>
	    <div id='root'/>
    </body>
</html> 
EOF

mkdir frontend
cat << EOF > frontend/$project_name.jsx
import React from 'react';
import ReactDOM from 'react-dom';

document.addEventListener("DOMContentLoaded", () => {
	const root = document.getElementById("root");
	// your root component here...
});
EOF

cat << EOF > webpack.config.js
const path = require('path');

module.exports = {
  context: __dirname,
  entry: "./frontend/$project_name.jsx",
  output: {
    path: path.resolve(__dirname, 'dist'),
    filename: "bundle.js"
  },
  module: {
    rules: [
      {
        test: /\.jsx?$/,
        exclude: /(node_modules)/,
        use: {
          loader: 'babel-loader',
          query: {
            presets: ['@babel/env', '@babel/react']
          }
        },
      }
    ]
  },
  devtool: 'source-map',
  resolve: {
    extensions: [".js", ".jsx", "*"]
  }
};
EOF

cat << EOF > .gitignore
node_modules/
dist/bundle.js
dist/bundle.js.map
EOF

webpack --mode=development

echo "NPM setup complete!"
