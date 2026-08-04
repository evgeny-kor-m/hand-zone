1. Create & Configure new Inbound Agent 'Python-Agent' in Jenkins
2. Create main.py file in Your -Public- GitHub Repository (simple hello world)
3. Create Jenkins Pipeline That Using Your Inbound Agent 'Slave' & Clone GitHub Repo & Run The main.py via 'python main.py' 
4. Testing in your host localhost:5000  
5. Basic: install manually python & pip advance: use python tool  
6. Please use environments + volume + port forwarding: 
JENKINS_URL JENKINS_SECRET JENKINS_AGENT_NAME

#### Prerequisites:
docker run --name jenkins -d -p 3000:3000 -p 9090:8080 -p 50000:50000 -v \
 jenkins-volume-persistent:/var/jenkins_home jenkins/jenkins:lts  

### Part 1.
#### create & Configure new Inbound Agent 'Docker-Agent' in Jenkins
Create Node: Jenkins > Nodes > New Node  
Jenkins > Nodes > dind-inbound-agent-slave > Configure
Fill:
- Name: dind-inbound-agent-slave  
- Remote root directory: /home/jenkins  
- Labels: jenkins-agent-slave-label  
- Launch method: Launch agent by connecting it to the controller  
Take the secret: secret dd2c4933a6784396.x.x.xx..x.xx.x.x.x.  

####  Use docker image:  https://hub.docker.com/r/jenkins/inbound-agent  
docker volume create jenkins-agent-volume

docker run -d \
--name jenkins-inbound-agent \
-e JENKINS_URL=http://172.17.0.2:8080 \
-e JENKINS_SECRET=edadce5d944117834ca8fb22274dc821356ce56de365a4c18e15bd78ea550752 \
-e JENKINS_AGENT_NAME=jenkins-inbount-slave \
-v jenkins-agent-volume:/home/jenkins \
    jenkins/inbound-agent:latest

### Part 2.
main.py print("Hello, World!")

### Part 3.
#### Create Jenkins Pipeline That Using Your Inbound Agent 'Slave':
- Definition: Pipeline script from SCM
- SCM: Git
- Connect Jenkins to GitHub: https://github.com/evgeny-kor-m/jenkins-labs.git  
- Branch Specifier: */main  
- Use existing (PAT): (jenkins_git_cred)  
- Script Path: ex-02-jenkins-inbound-slave/Jenkinsfile  
Create the Jenkinsfile  

### Part 4.
curl localhost:5000  

### Part 5.
as user root
```
docker exec -it --user root jenkins bash
apt-get install -y python3 python3-pip python3-venv
```
