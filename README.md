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

The application is setup to allow for switching between `CloudStore` and `RESTStore`. In order to allow for either to be used,  a protocol is setup called `Rremote 
