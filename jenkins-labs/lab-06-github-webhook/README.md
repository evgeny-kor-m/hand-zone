
### webhook EX 1
github repo -> trigger -> jenkins pipeline -> docker hub  
jenkins listen to triggers github send triggers  
using /github-webhook/ - basic webhook  

#### 1. configure Ngrok  
install ngrok in order to create static IP and proxy to your computer.  
https://ngrok.com/download/windows?tab=download

registrate  

- run ngrok.exe     
- ngrok config add-authtoken 3BfhaedAenZ3lAuY3KY5viQIIIF_7ixX7TgMjGArTTt7rFNFb
```
ngrok http 9090   

RES: Forwarding    https://lightless-rocco-climacterically.ngrok-free.dev -> http://localhost:9090  
```
#### 2. configure github webhook that send only Push event notifications
github > (Reposirory) jenkins-labs > settings > webhooks > Add webhook  
```
Fill:  
- Payload URL: <url from ngrok Forwarding> https://lightless-rocco-climacterically.ngrok-free.dev <and> /github-webhook/  
- Content type: application/json
- Let me select individual events: Pushes
- [v] Active  
```
#### 3. create jenkins pipeline that trigger when github push event happend 
Create pipeline: github-webhook-pipeline  
Jenkins > github-webhook-pipeline > configure  
```
Triggers:  
[v] GitHub hook trigger for GITScm polling  

Definition: Pipeline script from SCM
- SCM: Git
- Connect Jenkins to GitHub: https://github.com/evgeny-kor-m/jenkins-labs.git  
- Branch Specifier: */main  
- Use existing (PAT): (jenkins_git_cred)  
- Script Path: lab-06-github-webhook/Jenkinsfile  
Create the Jenkinsfile 
```

