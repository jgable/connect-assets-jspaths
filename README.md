connect-assets-jspaths
======================

An NPM module for outputting your [connect-assets](https://github.com/TrevorBurnham/connect-assets) javascript assets.  Useful for working with requireJS.

### Problems This Helps With

- You're using [requireJS](http://requirejs.org) and need to update the location of your modules after they have become minified and hashed.
- You're using [requireJS](http://requirejs.org) and need to get the url of a particular file to add as the `data-main` attribute of your script reference.

### Installation

`npm install connect-assets-jspaths`

* Note, there is a dependency on CoffeeScript.

### Server Side Usage

    assets = require "connect-assets"
    jsPaths = require "connect-assets-jspaths"
    
    # Snip ...
    
    app.use assets()
    # Exports the global function exportPaths() and jsUrl(); see below in View Helpers.
    jsPaths assets
    
    # Optionally, pass a log function to see progress
    # jsPaths assets, console.log

### View Usage

This module exports two global functions `exportPaths()` and `jsUrl()`.

    // Using this in your view
    != exportPaths("jsPaths")

    // Turns into this when rendered in production
    <script type="text/javascript">
        var jsPaths = { "main", "/builtAssets/js/main.13819282742.js" /* snip all the other file paths */ };
    </script>

    
    // Using this in your view
    - var mainJsPath = jsUrl("/js/main.js")
    script(type="text/javascript", data-main="#{mainJsPath}", src="//cdnjs.cloudflare.com/ajax/libs/require.js/2.0.2/require.min.js")    
    
    // Turns into this when rendered in production
    <script type="text/javascript" data-main="/builtAssets/js/main.13819282742.js" src="//cdnjs.cloudflare.com/ajax/libs/require.js/2.0.2/require.min.js"></script>

### Dynamic RequireJS Paths

Now that we have a variable with our requireJS friendly paths in it, we can set those paths in the RequireJS config

    # Example main.coffee file in /assets/js folder
    
    requirePaths =
      paths:
        jquery: "//cdnjs.cloudflare.com/ajax/libs/jquery/1.7.2/jquery.min"
        underscore: "//cdnjs.cloudflare.com/ajax/libs/underscore.js/1.3.3/underscore-min"
        backbone: "//cdnjs.cloudflare.com/ajax/libs/backbone.js/0.9.2/backbone-min"
        text: "/js/lib/text"
        handlebars: "/js/lib/handlebars"
        
    if jsPaths
      for own key, value of jsPaths
        # Fix up the lib references
        key = key.slice 4 if key.slice(0, 4) == "lib/"
        requirePaths.paths[key] = value 
    
    require.config
      paths: requirePaths.paths
    
      shim:
        jquery:
          exports: "$"
        underscore:
          exports: "_"
        backbone:
          deps: ["underscore", "jquery"]
          exports: "Backbone"
        
    require ['app'], (App) ->
        new App().initialize()

### Copyright

Created by [Jacob Gable](http://jacobgable.com).  MIT License; no attribution required.
