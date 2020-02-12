#!/usr/bin/env bash

source ~/.bashrc
test -e ~/.bash_mixpanel && source ~/.bash_mixpanel || true
test -e ~/.iterm2_shell_integration.bash && source ~/.iterm2_shell_integration.bash || true

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/evanpurcer/google-cloud-sdk/path.bash.inc' ]; then . '/Users/evanpurcer/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/evanpurcer/google-cloud-sdk/completion.bash.inc' ]; then . '/Users/evanpurcer/google-cloud-sdk/completion.bash.inc'; fi
