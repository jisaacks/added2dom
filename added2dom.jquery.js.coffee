# Options:
#   root: The root node in the dom to listen to, defaults to body
#   poll: The interval to use when falling back to polling

$ = jQuery

$.fn.extend
  added2dom: (callback, options={}) ->

    defaults =
      root: document.querySelector('body')
      poll: 100

    opts = _.extend(defaults, options)

    opts.root = $(opts.root).get(0) # strip element from jQuery

    matches = @

    MutationObserver = window.MutationObserver ? 
                       window.WebKitMutationObserver ?
                       window.MozMutationObserver

    if MutationObserver
      observer = new MutationObserver (mutations) ->
        matched = []
        _.each mutations, (mutation) ->
          _.each mutation.addedNodes, (node) ->
            _.each matches, (match) ->
              if match == node
                callback.apply(match)
                matched.push match
        matches = _.without(matches, matched...)
        @disconnect() unless matches.length

      observer.observe opts.root, 
        childList: true
        subtree:   true

    else
      # mutation observer is not supported, fall back to polling
      checkDomForElem = ->
        matched = []
        _.each matches, (match) ->
          if $(opts.root).find(match).length == 1
            callback.apply(match)
            matched.push match
        matches = _.without(matches, matched...)

        if matches.length
          setTimeout checkDomForElem, opts.poll
      checkDomForElem()

    @