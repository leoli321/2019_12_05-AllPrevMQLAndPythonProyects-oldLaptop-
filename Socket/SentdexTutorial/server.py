# -*- coding: utf-8 -*-
"""
Created on Wed Nov 13 14:36:55 2019

@author: gvega
"""

import socket
import time
import pickle

HEADERSIZE = 10

s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.bind((socket.gethostname(),1235))
s.listen(5)

while True:
    clientsocket, adress = s.accept()
    print(f"Connection from {adress} has been established!")
    
    d = {1: "Hey", 2: "There"}
    msg = pickle.dumps(d)
    
    msg = bytes(f'{len(msg):<{HEADERSIZE}}',"utf-8") + msg
    
    clientsocket.send(msg)