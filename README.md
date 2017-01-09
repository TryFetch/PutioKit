# WIP: PutioKit
[![Build Status](https://travis-ci.org/TryFetch/PutioKit.svg?branch=master)](https://travis-ci.org/TryFetch/PutioKit)

### A Swift framework for Put.io's API

This project is currently a work in process but aims to be a feature complete wrapper for Put.io's API. It's derived from the framework of the same name used it [Fetch](https://github.com/TryFetch/Fetch).

### Usage

In order to access the Put.io API you'll need to create an OAuth app and use its client ID and secret. The following static properties can be set on the main `Putio` class.

```swift
import PutioKit

Putio.clientId = 1234 // The client ID given when registering an app with Put.io
Putio.secret = "xxxxxxxxxxxxxxxxxxxx" // The client secret obtained when registering an app with Put.io
Putio.accessToken = "ABC123DE" // The user's access token obtained from OAuth
```

The main methods for interacting with the API are all included on the `Putio` class. Some model specific methods will be included elsewhere. For example there is a method for retrying a transfer on the `Transfer` object itself.

Some examples of methods and their usage can be seen below.

```swift
import PutioKit

// FILES

Putio.getFiles { files, error in
  print(files)
  print(error)
}

Putio.delete(files: [file1, file2]) { completed in
  print(completed)
}

// TRANSFERS

Putio.getTransfers { transfers, error in
  print(transfers)
  print(error)
}

Putio.cleanTransfers { completed in
  print(completed)
}      
```
