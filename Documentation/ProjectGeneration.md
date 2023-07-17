# Project generation
To be able to run the project you need to have a Xcodeproj file. As mentioned above we use [Tuist][tuist] for that. This way we can get rid of dealing with merge conflicts in project file and use other features [Tuist][tuist] offers.

Our projects usually have 3 build configurations and 3 environments, but to keep things simple our [Tuist][tuist] setup always generates a project with a single configuration and a single environment.

Our standard configurations are _Debug_ for Xcode development, _Beta_ for testing and _Release_ for App Store builds. Usually _Debug_ and _Beta_ configurations share its bundle identifier and are connected to the same testing app in TestFlight. Which configuration is generate to Xcode project file is determined by using `TUIST_CONFIGURATION` environment variable that should contain the configuration that should be generated - if it is missing, empty or its value doesn't match any of known values - _Debug_ is used.

Environments usually are _Development_, _Stage_ and _Production_. Which environment is generated is determined by using `TUIST_ENVIRONMENT` environment variable - if it is missing, empty or its value doesn't match any of known values - _Development_ is used.

As our project contains our [Tuist plugin][tuist plugin], or you might use [Tuist Dependencies](https://docs.tuist.io/guides/third-party-dependencies) you might also need to run `tuist fetch`, it is a good idea to run that command with the same environment variables as they might be used also in dependencies definition.

So to generate production app for App Store, you will need to run these commands:
```
TUIST_ENVIRONMENT=Production TUIST_CONFIGURATION=Release tuist fetch
TUIST_ENVIRONMENT=Production TUIST_CONFIGURATION=Release tuist generate
```