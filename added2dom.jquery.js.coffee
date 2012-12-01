$ = jQuery

$.fn.extend
  added2dom: (callback) ->

    matches = @

    MutationObserver = window.MutationObserver ? 
                       window.WebKitMutationObserver ?
                       window.MozMutationObserver
    
    body = document.querySelector('body')

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

      observer.observe body, 
        childList: true
        subtree:   true

    else
      # mutation observer is not supported, fall back to polling
      checkDomForElem = ->
        matched = []
        _.each matches, (match) ->
          if $(body).find(match).length == 1
            callback.apply(match)
            matched.push match
        matches = _.without(matches, matched...)

        if matches.length
          setTimeout checkDomForElem, 100
      checkDomForElem()