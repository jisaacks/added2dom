## added2dom

added2dom is a jquery plugin that executes a callback when the matched elements are added to the DOM.

### Usage:

    $div = $('<div id="add_me">Here I am!</div>')
    $div.added2dom ->
      # do something dom specific
    $("body").append($div)

    # It also works with multiple elements
    $div  = $('<div id="add_me">Here I am!</div>')
    $div2 = $('<div id="add_me_too">me too!</div>')
    $div.add($div2).added2dom ->
      alert "I am now in the DOM!"
      $(this).css 'color', 'red' 

### Requirements
 - **[jQuery](http://jquery.com/)** *obviously*
 - **[underscore.js](http://underscorejs.org/)**
 - **[CoffeeScript](http://coffeescript.org/)** If you don't use CoffeeScript, feel free to [convert](http://js2coffee.org/) this to JavaScript before using it.

### How it works
This uses the new [MutationObserver](http://dvcs.w3.org/hg/domcore/raw-file/tip/Overview.html#mutation-observers) object to listen for mutations to a specified root node and checks each mutation to see if it was one of the elements we care about being added. If MutationObserver is not supported then it falls back to a polling system that checks the root node to see if it contains any matched elements every iteration.

You can set the root node and the interval when calling added2dom:
    
    $el.added2dom (->
      # run when added to dom
    ),
      root: $("#main") # defaults to body
      poll: 5000       # defaults to 100


### Caveat
This stops listening once the element is added, so if you plan to add the same element to the dom multiple times you will need to add this each time. I may add support for this if I get requests but I don't currently feel the need to.