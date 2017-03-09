#!/usr/bin/env bash
#                      __ __       ___
#                     /\ \\ \    /'___`\
#                     \ \ \\ \  /\_\ /\ \
#                      \ \ \\ \_\/_/// /__
#                       \ \__ ,__\ // /_\ \
#                        \/_/\_\_//\______/
#                           \/_/  \/_____/
#                                         Algoritimos
#
#
#      Author: Ivan Lopes
#        Mail: ivan (at) 42algoritmos (dot) com (dot) br
#        Site: http://www.42algoritmos.com.br
#     License: gpl
#       Phone: +1 561 801 7985
#    Language: Shell Script
#        File: install.sh
#        Date: Sex 17 Fev 2017 05:33:42 BRST
# Description:
#
# ----------------------------------------------------------------------------
#
# ----------------------------------------------------------------------------

##############################################################################
##############################################################################
##############################################################################

# ----------------------------------------------------------------------------
# Run!
dir_mutt=${HOME}/developer/mutt
dir_gmail=${HOME}/.mutt-gmail

links=(
$dir_gmail
${HOME}/.msmtprc
${HOME}/.muttrc
${HOME}/.offlineimaprc
)
for _l in ${links[*]};do
  test -L $_l && rm $_l
done

ln -s $dir_mutt/muttrc.gmail ${HOME}/.muttrc
ln -s $dir_mutt $dir_gmail

links=(
offlineimaprc
msmtprc
)
for _l in ${links[*]};do
  ln -s $dir_mutt/$_l ${HOME}/.$_l
done

mkdir -p $dir_mutt/mail
mkdir -p $dir_mutt/temp

echo import keyring > ~/.offlineimap.py

cat > offlineimaprc << EOF
[general]
ui = TTY.TTYUI
accounts = UFF,UFRJ
pythonfile=~/.offlineimap.py
fsync = False

[Account UFF]
localrepository = UFF-Local
remoterepository = UFF-Remote
status_backend = sqlite
postsynchook = notmuch new

[Repository UFF-Local]
type = Maildir
localfolders = ${dir_mutt}/mail/ivan-uff.com
nametrans = lambda folder: {'drafts':  '[Gmail]/Drafts',
                            'sent':    '[Gmail]/Sent Mail',
                            'flagged': '[Gmail]/Starred',
                            'trash':   '[Gmail]/Trash',
                            'archive': '[Gmail]/All Mail',
                            }.get(folder, folder)

[Repository UFF-Remote]
maxconnections = 1
type = Gmail
sslcacertfile = /etc/ssl/certs/ca-certificates.crt
remoteuser = ivanlopes@id.uff.br
remotepasseval = keyring.get_password('gmail', 'ivanlopes@id.uff.br')
realdelete = yes
nametrans = lambda folder: {'[Gmail]/Drafts':    'drafts',
                            '[Gmail]/Sent Mail': 'sent',
                            '[Gmail]/Starred':   'flagged',
                            '[Gmail]/Trash':     'trash',
                            '[Gmail]/All Mail':  'archive',
                            }.get(folder, folder)

folderfilter = lambda folder: folder not in ['[Gmail]/Trash',
                                             'Nagios',
                                             'Django',
                                             'Flask',
                                             '[Gmail]/Important',
                                             '[Gmail]/Spam',
                                             ]

[Account UFRJ]
localrepository = UFRJ-Local
remoterepository = UFRJ-Remote
status_backend = sqlite
postsynchook = notmuch new

[Repository UFRJ-Local]
type = Maildir
localfolders = ${dir_mutt}/mail/ivan-ufrj.com
nametrans = lambda folder: {'drafts':  '[Gmail]/Drafts',
                            'sent':    '[Gmail]/Sent Mail',
                            'flagged': '[Gmail]/Starred',
                            'trash':   '[Gmail]/Trash',
                            'archive': '[Gmail]/All Mail',
                            }.get(folder, folder)

[Repository UFRJ-Remote]
maxconnections = 1
type = Gmail
sslcacertfile = /etc/ssl/certs/ca-certificates.crt
remoteuser = lopesivan@poli.ufrj.br
remotepasseval = keyring.get_password('gmail', 'lopesivan@poli.ufrj.br')
realdelete = yes
nametrans = lambda folder: {'[Gmail]/Drafts':    'drafts',
                            '[Gmail]/Sent Mail': 'sent',
                            '[Gmail]/Starred':   'flagged',
                            '[Gmail]/Trash':     'trash',
                            '[Gmail]/All Mail':  'archive',
                            }.get(folder, folder)

folderfilter = lambda folder: folder not in ['[Gmail]/Trash',
                                             'Nagios',
                                             'Django',
                                             'Flask',
                                             '[Gmail]/Important',
                                             '[Gmail]/Spam',
                                             ]
# vim: set ts=4 sw=4 tw=78 ft=python:
EOF



# ----------------------------------------------------------------------------
exit 0
