# Bash-Scripts
Various bash scripts I've written throughout the years. Feel free to use and modify as desired!

The scripts 'build.sh' and the two beginning in 'ddog' are scripts I've written and use to automate package maintaining of the Arch Linux - Arch User Repository package of the Datadog agent. These both utilize the Datadog agent as well to send in APM traces, events, & logs to Datadog. These scripts rely on environment variables being set for `DD_API_KEY` & `DD_APP_KEY` for your own Datadog API & Application keys respectively.

`ddogAgentCheck.sh` - Sends Agent Version & Sha256 hashes for AMD64/AARCH64 as an event in Datadog
`ddogAgentVerLogger.sh` - Sends Agent Version & Sha256 hashes for AMD64/AARCH64 as a log in Datadog
`build.sh` - What I use to modify and commit an updated PKGBUILD to the AUR (PKGBUILD not included, but may still be useful for newer AUR package maintainers! =] )
