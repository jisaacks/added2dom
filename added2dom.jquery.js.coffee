# added2dom by JD Isaacks (jisaacks.com)

# Copyright (c) 2012 John Isaacks

# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:

# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

# Options:
#   root: The root node in the dom to listen to, defaults to document
#   poll: The interval to use when falling back to polling

$ = jQuery

$.fn.extend
  added2dom: (callback, options={}) ->

    defaults =
      root: document
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
        @disconnect() unless matches.length > 0

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