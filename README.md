# Robots and Pencils - iOS Code Challenge
 
 ## Requirements
 * Xcode 11.1 _GM_
 
 > Lets say you have instances of two data types, RPComment and RPAnnotation, that need to get saved to a Remote Store of some type.
 Please provide draft code, pseudo-code or a clear description that indicates how you would save these objects to a Remote Store in such a fashion as to allow:
 > a. The Remote Store to be changed at some unknown point in the future, for example, from Firebase to a GraphQL server, minimizing impact on the iOS code – particularly avoiding direct changes to the RPComment class itself. (Don’t worry about the API to the Remote Store unless that is key to your solution.)
 > b. The design pattern(s) adopted and implemented for RPComment to allow saving RPAnnotation and any other future objects with minimal additional code.

## Models
In this code sample, we have two data model structs:
* `RPComment`
* `RPAnnotation`

It's assumed that RPComment is a comment of an annotation or _child_ of annotation. Therefore, there is a relationship setup between these two models.

## Storage

The application is setup to allow for switching between `CloudStore` and `RESTStore`. In order to allow for either to be used,  a protocol is setup called `RemoteStore`.

### `RemoteStore`

`RemoteStore` is a protocol for running CRUD operations for  `RPComment` and  `RPAnnotation`. To switch between the different `RemoteStore` implementations, change the Schema Run...Environement Variables to either _REST_ or _CLOUD_. You can check `SceneDelegate.swift` where the `RemoteStore` is set and used throughout the application via the SwiftUI `EnvironmentObject` `StoreObject`.  There are two implementations:

### `CloudStore` 

`CloudStore` is an implementation of `RemoteStore`. Despite the name, `CloudStore` uses locally generated data each time the application is run using the Swift Package `Fakery`. Regardless of the fact the data is reset each time the application is run, the comments and annotations can be updated via the application.  

### `RESTStore` 

`RESTStore` is an implementation of `RemoteStore` which uses [a REST API based on the node-js `json-server` package](https://glitch.com/~cumbersome-base). At the initial run of the server, a set of fake data is generated. `json-server` sets up an API automatically for the data. In this case there are available CRUD REST calls for `annotations` and `comments`. As a result, these REST calls are being used by the application. For details on how `json-server` is used, check out [the github project](https://github.com/typicode/json-server). 

## Views

The application does use SwiftUI for implementing the view. The application follow a basic navigation pattern:

* List of Annotations
* Annotation with Comments *or* New Annotation
* New Comment
