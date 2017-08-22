jQuery ->
  window.plum_viewer_loader = new PlumViewerLoader($("#view"))
class PlumViewerLoader
  constructor: (@element) ->
    return unless this.element.length > 0
    this.build_viewer(this.manifest(), this.config(), this.src())
  manifest: ->
    this.element.data("manifest")
  config: ->
    this.element.data("config")
  src: ->
    this.element.data("src")
  build_viewer: (manifest, config, src) ->
    element = $(document.createElement('div'))
    element.addClass('uv')
    element.attr('data-config', config)
    element.attr('data-uri', manifest)
    script_tag = $(document.createElement('script'))
    script_tag.attr('id', 'embedUV')
    script_tag.attr('src', src)
    this.element.append(element)
    this.element.append(script_tag)
    this.element.before($("<hr class='clear'/>"))
