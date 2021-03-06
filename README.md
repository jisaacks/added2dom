## added2dom

added2dom is a jquery plugin that executes a callback when the matched elements are added to the DOM.

### Usage:

***CoffeeScript:***

```coffeescript
$div = $('<div/>')
$div.added2dom ->
  # do something dom specific
  $div.text $div.height()

# the callback will be triggered
# when the $div is added to the dom
$("body").append($div)
```  

```coffeescript
# It also works with multiple elements
$div1 = $('<div>One</div>')
$div2 = $('<div>Two</div>')
$div1.add($div2).added2dom ->
  console.log $(this).text()

$("body").append($div1) # output: One
$("body").append($div2) # output: Two
```   

***JavaScript:***

```javascript
var $div = $('<div/>');

$div.added2dom(function() {
  // do something dom specific
  return $div.text($div.height());
});

// the callback will be triggered
// when the $div is added to the dom
$("body").append($div);
```

```javascript
// It also works with multiple elements
var $div1 = $('<div>One</div>');
var $div2 = $('<div>Two</div>');
$div1.add($div2).added2dom(function() {
  return console.log($(this).text());
});

$("body").append($div1);
$("body").append($div2);
```

### Requirements
 - **[jQuery](http://jquery.com/)** *obviously*
 - **[underscore.js](http://underscorejs.org/)**

### Installation
 - **JavaScript:** *Use /lib*
 - **CoffeeScript:** *Use /src*

### How it works
This uses the new [MutationObserver](http://dvcs.w3.org/hg/domcore/raw-file/tip/Overview.html#mutation-observers) object to listen for mutations to a specified root node and checks each mutation to see if it was one of the elements we care about being added. If MutationObserver is not supported then it falls back to a polling system that checks the root node to see if it contains any matched elements every iteration.

You can set the root node and the interval when calling added2dom:  
***CoffeeScript:***
```coffeescript
$el.added2dom (->
  # run when added to dom
),
  root: $("#main") # defaults to document
  poll: 5000       # defaults to 100
```
***JavaScript:***
```javascript
$el.added2dom((function() {
  // run when added to dom
}), {
  root: $("#main"), // defaults to document
  poll: 5000        // defaults to 100
});
```


### Caveat
This stops listening once the element is added, so if you plan to add the same element to the dom multiple times you will need to add this each time. I may add support for this if I get requests but I don't currently feel the need to.

[![endorse](http://api.coderwall.com/jisaacks/endorsecount.png)](http://coderwall.com/jisaacks)