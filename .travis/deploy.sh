#!/bin/bash
# Decrypt the private SSH key
openssl aes-256-cbc -K $encrypted_f217180e22ee_key -iv $encrypted_f217180e22ee_iv -in .travis/id_rsa.enc -out ~/.ssh/id_rsa -d

# Set the permission of the private SSH key
chmod 600 ~/.ssh/id_rsa

# Start SSH agent
eval $(ssh-agent)

# Add the SSH private key to the system
ssh-add ~/.ssh/id_rsa

# Hugo build site
hugo -t NexT

#Echo somethings
ls -al
pwd