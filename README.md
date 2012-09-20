connect-assets-jspaths
======================

An NPM module for outputting your [connect-assets](https://github.com/TrevorBurnham/connect-assets) javascript assets.  Useful for working with requireJS.

### Problems This Helps With

- You're using [requireJS](http://requirejs.org) and need to update the location of your modules after they have become minified and hashed.
- You're using [requireJS](http://requirejs.org) and need to get the url of a particular file to add as the `data-main` attribute of your script reference.

### Installation

`npm install connect-assets-jspaths`

* Note, there is a dependency on CoffeeScript.

### Usage

assets = require "connect-assets"
jsPaths = require "connect-assets-jspaths"

# Snip ...

app.use assets()
jsPaths assets

# Optionally, pass a log function to see progress
# jsPaths assets, console.log

### Copyright

Created by [Jacob Gable](http://jacobgable.com).  MIT License; no attribution required.
