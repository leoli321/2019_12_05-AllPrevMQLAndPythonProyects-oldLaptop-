# -*- coding: utf-8 -*-
"""
Created on Thu Nov 14 10:12:24 2019

@author: gvega
"""

import socket
import pickle

HEADERSIZE = 10


s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.connect((socket.gethostname(), 1235))

while True:
	full_msg = b""
	new_msg = True

	while True:
		msg = s.recv(16)
		if new_msg:
			print(f"new message length: {msg[:HEADERSIZE]}")
			msglen = int(msg[:HEADERSIZE])
			new_msg = False

		full_msg += msg

		if len(full_msg)-HEADERSIZE == msglen:
			print("full msg recvd")
			d = pickle.loads(full_msg[HEADERSIZE:])
			print(d)
			new_msg = True
			full_msg = b'' #b es bytes
	print(full_msg)