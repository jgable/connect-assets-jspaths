jsPrimer = require "connect-assets-jsprimer"

exportPathsHelper = (assetsModule, log) ->
  throw new Error "Could not load assets module properties" if not assetsModule?.instance?.options?.helperContext?.js?.root?
  
  assets = assetsModule.instance
  
  context = assets.options.helperContext

  baseUrlDir = context.js.root

  prePath = "#{baseUrlDir}/"
  prePathLength = prePath.length
  
  trimJsExt = (file) ->
    # Trim the end of the file if it has a .js extension
    return file.slice(0, -3) if file.slice(-3) == ".js"

    file

  exportPaths = {}
  for own route, paths of assets.cachedRoutePaths
    trimmedRoute = route
    trimmedRoute = route.slice prePathLength if route.slice(0, prePathLength) == prePath

    # Trim the end of the file if it has a .js extension
    trimmedRoute = trimJsExt trimmedRoute

    exportPaths[trimmedRoute] = trimJsExt paths[0]

  getPathsScript = (varName = "connectAssets") ->
    """
    <script type="text/javascript">
      var #{varName} = #{JSON.stringify(exportPaths)};
    </script>
    """

  jsUrl = (fileName) ->
    # Strip the leading /
    fileName = fileName.slice(1) if fileName[0] is "/"
    assets.cachedRoutePaths[fileName]?[0]

  context.exportPaths = getPathsScript
  context.jsUrl = jsUrl

module.exports = (assets, log, changedCallback, doneWatching) ->
    # Assuming that if they passed a changedCallback and done they want to watch.
    if changedCallback and doneWatching
      return jsPrimer.loadAndWatchFiles assets, log, changedCallback, doneWatching

    # Otherwise, just load the files.
    jsPrimer.loadFiles assets, log
    exportPathsHelper assets, log
