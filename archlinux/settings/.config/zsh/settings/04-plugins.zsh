#!/bin/zsh

# Install plugins into the $gitdir defined in .zshrc

## Add plugins to array in the format of github user / repository name
local -a plugins=(
    Aloxaf/fzf-tab                                # Use FZF for auto-completion
    marlonrichert/zsh-edit                        # Better keyboard shortcuts
    zsh-users/zsh-autosuggestions                 # Inline suggestions
    zdharma-continuum/fast-syntax-highlighting    # Command-line syntax highlighting
    MichaelAquilina/zsh-you-should-use            # Suggest command aliases
    DevExUtils/aws-utils-zsh                      # AWS profile selector and utilites
    Bhupesh-V/ugit                                # Undo git actions
    wfxr/forgit                                   # Git FZF interactions and aliases
    reegnz/jq-zsh-plugin                          # jq interactive filter builder
)

# Speed up the first startup by cloning all plugins in parallel.
# Does not clone plugins already downloaded twice.
znap clone $plugins

# Load each plugin, one at a time.
local p=
for p in $plugins; do
  znap source $p
done