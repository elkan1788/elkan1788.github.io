---
title: The gpg signature failed when publishing jar to Maven
url: 2017/05/17/maven-deploy-center-sign-failed.html
date: "2017-05-17 17:02:23"
tags: 
  - Maven
  - Tools
  - Mac
categories:
  - Maven
---


For a long time did not maintain their own open source projects, this time in the repair bug release encountered failure, inspection found that the reason is because of gpg signature failure, no way to change mac computer some operations are not familiar with is a bit depressed. 


On how to share their JAR to Maven central warehouse, there are a lot of resources on the Internet, you can try it yourself, in fact, it is not difficult, there is no need to worry about English. 

Share a   GitBookorganized by someone else: ["Published to CentralWarehouse"](https://skyao.gitbooks.io/leaning-maven/content/public/central/).

<!--more-->

```
[INFO] --- maven-gpg-plugin:1. 6:sign (sign-artifacts) @ mpsdk4j ---
gpg: Failed to sign: Inged  ioctl  for device
gpg: signing failed: Inappropriate ioctl for device
```

Above is the GPG in the signature of the problem, simply literally, there is an inappropriate ioctl for this device,do not understand what is. Finally, a step-by-step exploration found that because the servers that manage GPG are not available, a new server was found on the Internet to re-upload as follows:

```
gpg --keyserver hkp://pgp.mit.edu --send-keys DAB131AA5564DCF176

#如果不放心的话, you can check it out using the command below
gpg --keyserver hkp://pgp.mit.edu --recv-keys DAB131AA5564DCF176
```

Well, repack the release jar package, very happy to see the results of SUCCESS, closed. 
