fish_vi_key_bindings

# ctrl-p == `vv`, like search files in vim
bind -M insert \cp vv

# ctrl-t == 'ftags'
bind -M insert \ct ftags

# ctrl-o == `cdp`, interactive zoxide wrapper
bind -M insert \co cdp

# forground last job
bind -M insert \cq fg_

# Control+C to clear the input line:
bind -M insert \cc kill-whole-line repaint
