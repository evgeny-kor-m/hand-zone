docker volume create <>

docker run -d
--name inbound-agent-slave
-e JENKINS_URL=http://172.17.0.2:8080
-e JENKINS_SECRET=ba329a7c87aa5d61c7d83a4f793391278b6b45be01e95d62bcc72a54316ac8e5
-e JENKINS_AGENT_NAME=jenkins-inbound-agent
-v jenkins_slave_data:/home/jenkins
jenkins/inbound-agent:latest

8080 - dashboard port 50000 - inbound agent port