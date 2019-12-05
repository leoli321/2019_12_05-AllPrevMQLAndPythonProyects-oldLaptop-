# -*- coding: utf-8 -*-
"""
Created on Sun Oct 13 13:27:14 2019

@author: gvega
"""
import gym 

env = gym.make("MountainCar-v0")
env.reset()

DISCRETE_OS_SIZE= [20]*len(env.observation_space.high)
discrete_os_win_size = (env.observation_space.high-env.observation_space.low)/DISCRETE_OS_SIZE



done = False

while not done:
    action = 2
    new_state, reward, done, _ = env.step(action)
    env.render()
    
env.close()