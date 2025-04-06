# Premake Dependency Fetcher
A simple LUA script that you can incorporate into your Premake build system for dependency fetching.

# Requirements
You must have Git installed on your machine in order to use this script:
https://git-scm.com/downloads

It should work on any platform supporting Premake, such as Windows, Linux, and MacOS. It simply runs Git commands through your OS's local terminal

# Use
The ```os.execute``` command in Lua blocks execution of other code until it finishes, which is desired behavior for this case as this should run **before** Premake
builds project files. So we'll define this at the top of our build file:
```
local DependencyFetcher = require "dependency_fetcher" -- Or whatever you want to name it
DependencyFetcher.Setup() -- Check and fetch dependencies before execution of Premake
```

And if done correctly it will check and fetch dependencies, then build as normal.
