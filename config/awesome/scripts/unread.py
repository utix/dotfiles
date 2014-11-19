#!/usr/bin/python

import imaplib
import string
import os

#first field is imap server, second - port (993 for gmail SSL IMAP)
M=imaplib.IMAP4_SSL("ssl0.ovh.net", 993)
#first field is imap login (gmail uses login with domain and '@' character), second - password
M.login("XXXXXXXXXXXXXXX", "XXXXXXXXXXXXXX")

status, counts = M.status("Inbox", "(MESSAGES UNSEEN)")

M.logout()
unread = string.atoi(counts[0].split()[4][:-1]);

M=imaplib.IMAP4_SSL("ssl0.ovh.net", 993)
M.login("XXXXXXXXXXXXXXX", "XXXXXXXXXXXXXX")

status, counts = M.status("Inbox", "(MESSAGES UNSEEN)")
M.logout()

unread += string.atoi(counts[0].split()[4][:-1]);

if unread == 0:
    print " 0 "
    os.system("xset -led 3")
else:
#red fg color when you have unseen mail
    print "<span color=\"red\">  <b>" + str(unread) + "</b>  </span>"
    os.system("xset led 3")

