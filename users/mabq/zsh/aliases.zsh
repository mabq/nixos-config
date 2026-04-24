# Add options to core utils:
# alias chgrp='chgrp --preserve-root'
# alias chmod='chmod -c --preserve-root'
# alias chown='chown -c --preserve-root'
# alias cp='cp -iv'
alias la='eza -al'
# alias ln='ln -iv'
alias mkdir='mkdir -p'
# alias mv='mv -iv'
# alias rm='rm -iv --preserve-root'


# # Shortcuts/renames:
# alias cpuinfo='bat /proc/cpuinfo'
# alias drivers='lspci -k'
# alias e='nvim'
# alias format-disk='sudo mkfs.exfat' # format external disk for any OS (no partitions)
# alias plex='flatpak run tv.plex.PlexDesktop'
# alias fontname="fc-query -f '%{family[0]}\n'" # pass the font path as argument
# #alias fonts='fc-list : family | sort | uniq | sk --layout=reverse'
# alias fonts='ghostty +list-fonts | fzf'
# alias ga='git add'
# alias gc='git commit'
# alias gca='git commit --amend'
# alias gp='git push'
# alias gl='git log --oneline --graph'
# alias gpuinfo='lspci | grep -E "VGA|3D"'
# alias gs='git status'
# alias h='history -i 1'
# alias keycodes="xev | awk -F '[ )]+' '/^KeyPress/ { a[NR+2] } NR in a { printf \"%-3s %s\n\", \$5, \$8 }'"
# alias logout='loginctl terminate-user $USER'
# alias mdserve='mdbook serve --open'
# alias monitor='btm'
# alias mousecodes='xev -event button | grep button'
# alias nc='new-component' # https://www.joshwcomeau.com/react/file-structure/#more-boilerplate-11
# # alias nvim='NVIM_APPNAME="nvim-kickstart" nvim'
# alias path='echo $PATH | tr ":" "\n"'
# alias psbyuser='ps --no-headers -Leo user | sort | uniq --count'
# alias reboot='systemctl reboot'
# alias restart-spotifyd='systemctl --user restart spotifyd.service'
# alias sha256='shasum -a 256'
# alias shutdown='systemctl poweroff'
# # alias suspend='swaylock; systemctl suspend'
# alias suspend='systemctl suspend' # hypridle will automatically run hyprlock on suspend
# alias ta='tmux attach'
# alias toen='trans es:en'
# alias toes='trans en:es'
# alias trash='trash-put'
# alias tree='eza --tree'
# alias wifi='nmtui'
# alias y='yy'
# # the uuid of a disk will change when formatted
# # alias mount-series='sudo mount /dev/disk/by-uuid/EBC6-97B8 /mnt/series'
# alias ga='git add'
# # alias umount-series='sudo umount /mnt/series && sleep 3 && sudo hdparm -y /dev/disk/by-uuid/EBC6-97B8'
# # alias mount-alejandro='sudo mount /dev/disk/by-uuid/04D0-1DBF /mnt/alejandro'
# # alias umount-alejandro='sudo umount /mnt/alejandro && sleep 3 && sudo hdparm -y /dev/disk/by-uuid/04D0-1DBF'
# # alias mount-courses='sudo mount /dev/disk/by-uuid/7443-E3E7 /mnt/courses'
# # alias umount-courses='sudo umount /mnt/courses && sleep 3 && sudo hdparm -y /dev/disk/by-uuid/7443-E3E7'
#
# # Requests:
# alias extip='curl icanhazip.com'
# alias extipjson='curl https://ipapi.co/json/'
# # alias speedtest='curl -s https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py | python -'
# alias weather='curl wttr.in'
#
#
# # Safety nets:
# alias fsck='echo "Never use file system repair software such as fsck directly on an encrypted volume, or it will destroy any means to recover the key used to decrypt your files. Such tools must be used on the decrypted (opened) device instead"'
#
#
