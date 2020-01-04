source ~/.bashrc

if [[ -f '~/.bash_mixpanel' ]]; then
  source ~/.bash_mixpanel
fi

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/evanpurcer/google-cloud-sdk/path.bash.inc' ]; then . '/Users/evanpurcer/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/evanpurcer/google-cloud-sdk/completion.bash.inc' ]; then . '/Users/evanpurcer/google-cloud-sdk/completion.bash.inc'; fi
