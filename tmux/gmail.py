#! /usr/bin/python
# -*- coding: utf-8 -*-

"""
Script to print formatted output containing the number of my unread Gmail
emails, for use in my `tmux` statusline.
"""

import imaplib
import os

def count_unread_emails():
	"""
	Queries Gmail's IMAP server for my unread emails.

	Returns:
		(str) A string representation (for `tmux` consumption) of my number of
		unread emails.
	"""

	obj = imaplib.IMAP4_SSL("imap.gmail.com", "993")
	obj.login(*get_gmail_credentials())
	obj.select()

	num_unread = len(obj.search(None, "UnSeen")[1][0].split())

	tmux_str = "#[%%sfg=colour%%d,bg=colour%%d] ✉ %d #[nobold]" % num_unread
	return tmux_str % (
		("bold,", 255, 196) if 0 < num_unread else ("", 255, 237)
	)

def get_gmail_credentials():
	"""
	Retrieves my Gmail credentials from a file outside of `.dotfiles/`.

	Returns:
		(tuple of str) A tuple in the following format: (username, password).
	"""

	with open(os.path.expanduser("~/.sensitive/tmux_gmail_credentials.csv"))\
		as cred_file:
		return cred_file.read().rstrip("\n").split(",")

if __name__ == "__main__":
	print(count_unread_emails())
