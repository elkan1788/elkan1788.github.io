#!/bin/bash
# Decrypt the private SSH key
openssl aes-256-cbc -K $encrypted_c9744fe6174f_key -iv $encrypted_c9744fe6174f_iv -in .travis/id_rsa.enc -out ~/.ssh/id_rsa -d

# Set the permission of the private SSH key
chmod 600 ~/.ssh/id_rsa

# Start SSH agent
eval $(ssh-agent)

# Add the SSH private key to the system
ssh-add ~/.ssh/id_rsa

# Set Git config
git config --global user.name "凡梦星尘"
git config --global user.email elkan1788@gmail.com

# Clean, generate and deploy to Pages server
hexo clean && hexo g && hexo deploy
