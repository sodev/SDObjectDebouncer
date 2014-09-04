SDObjectDebouncer
=================

Debouncing for iOS allowing passing of an object to a selector

##Usage
SDObjectDebouncer is a category of NSObject, extending it to allow the debouncing of any object
to perform any selector with an argument

##Example
[self performSelector:@selector(selectorWithObject:)
           withObject:object
 withDebounceDuration:2];
```
