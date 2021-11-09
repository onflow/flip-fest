# General
- A new plugin, [Cadence](https://plugins.jetbrains.com/plugin/17764-cadence) has been developed, for Intellij Platform based IDEs
- The plugin was developed based on the official Intellij guide [](https://plugins.jetbrains.com/docs/intellij/custom-language-support-tutorial.html)
- The code of the plugin can be found on the [public github repository](https://github.com/cadence-tools/cadence-for-intellij-platform) under the open source GPLv3 license
- Instructions on how to get, use, and modify the plugin have been documented in the [README](https://github.com/cadence-tools/cadence-for-intellij-platform/blob/main/README.md) file

# Milestones
- The plugin provides syntax highlighting for Cadence language files, identified by the `.cdc` extension (milestone 1)
- The plugin provides language server protocol support (since version 0.4), by utilizing the [lsp4intellij](https://github.com/ballerina-platform/lsp4intellij/) library (milestone 2)
- The plugin is compatible with all intellij platform IDEs from versions 2021.2.2 and up, for example Intellij, GoLand, PyCharm, PhpStorm etc (milestone 3)
- The plugin is published in the [Jetbrains marketplace](https://plugins.jetbrains.com/plugin/17764-cadence), and can be installed directly by searching in the supported IDEs

# Extra
- The plugin includes settings to configure the colors of the different tokens of the syntax highlighting
- The syntax highlighting will be adapted to any color scheme / theme the user uses, as we follow platform defaults
- The plugin has been developed as a [dynamic plugin](https://plugins.jetbrains.com/docs/intellij/dynamic-plugins.html), allowing hot reload without restart of the IDE
- The plugin has functionality (configurable by settings) to log all the incoming and outgoing messages to the LSP server, to enable debugging / improvements int he future 
- The plugin is suggested automatically by Intellij for `.cdc` files, and has already over 50 unique downloads

# Links
- https://github.com/cadence-tools/cadence-for-intellij-platform
- https://plugins.jetbrains.com/plugin/17764-cadence