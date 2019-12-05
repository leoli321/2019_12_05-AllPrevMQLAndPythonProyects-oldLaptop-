# -*- coding: utf-8 -*-
"""
Created on Wed Nov 13 14:36:55 2019

@author: gvega
"""

import socket

s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.bind((socket.gethostname(),1234))
s.listen(5)

while True:
    clientsocket, adress = s.accept()
    print(f"Connection from {adress} has been established!")
    clientsocket.send(bytes("Welcome to the server!", "utf-8"))