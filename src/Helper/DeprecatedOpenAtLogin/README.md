# DeprecatedOpenAtLogin

DeprecatedOpenAtLogin is for macOS 12 or prior.

Since macOS 13, there are the following API that register/unregister the application to login items.

-   `SMAppService.mainApp.register()`
-   `SMAppService.mainApp.unregister()`

But macOS 12 or prior, there are only deprecated API which do not work in sandbox.
So, we have to prepare XPC Service to call these deprecated API.
