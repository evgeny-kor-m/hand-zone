## The Assignment
Company: Trigo Role: DevOps Engineer Time limit: 2 hours
Trigo's solution includes proprietary sensors based on embedded microcontrollers running bare-metal software under tight resource limits (low CPU, low memory). Those devices cannot run modern tooling such as Docker or Consul agents, but they do expose an HTTP server with a dedicated metrics endpoint.  
Store operators can change which sensors participate, so the active inventory updates frequently.
In this exercise, you will implement a custom service discovery mechanism for Prometheus so that Prometheus keeps monitoring the correct set of sensors as configuration changes.
### Exercise
The inventory service exposes an HTTP endpoint that returns the list of hosts for the currently active sensors.

#### For example:
curl -XGET http://localhost:1337/inventory

#### returns the hostnames to monitor:
json
["sensor_1", "sensor_2", "sensor_12", "sensor_7", "sensor_99"]

### Requirements
#### Goals:
- Service discovery: Implement custom Prometheus service discovery that queries the inventory endpoint and produces target groups for those sensors.
- Runtime stack: Provide a minimal Docker Compose file or Helm chart that runs the full stack, with Prometheus listening on HTTP TCP 9090 and configured to scrape the sensor targets via your discovery.
Note that the hosts provided by the inventory are dummy, and that's fine if your Prometheus isn't able to connect to them. The goal is just to add them as targets.

#### Quality:
- Keep the solution clear and maintainable, follow sensible best practices, and prefer current stable versions of dependencies where practical.
#### Constraints:
- Do not modify the inventory service code.
- Complete the exercise within two hours (maximum).
#### Submission:
- Fork this repository, push your solution, open a pull request to our repository, and send us a link.
#### Tools, references, and questions
- You may use any language, framework, library, or code snippets you find helpful.
- You may use any source of information, including AI tools. Please note that we can identify submissions generated with AI, and in such cases, stricter evaluation criteria may be applied.

## Solution 
```
cd inventory_server/ 
docker build --no-cache -t inventory:latest -f Dockerfile . 
docker run --name inv-container -d -p 1337:1337  inventory:latest

cd inventory_adapter
docker build -t adapter:latest -f Dockerfile .
docker run --name inv-adapter -d -p 9100:9100 -e inventory_ser_host="http://inv-container:1337/inventory"  adapter:latest

docker compose up -d
docker compose down

```
prometheus
count(up{job="inv-adapter-job"})