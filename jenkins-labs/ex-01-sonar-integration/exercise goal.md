## **SonarQube Exercise (EX)**

---

### **Part 1: Setup Your Environment**

1. **Create a Private Git Repository**

   * Create a new private repository for this exercise.

2. **Deploy Jenkins via Docker**

   * Run Jenkins in a Docker container on your host machine.
   * Ensure you configure a **persistent volume** for Jenkins data.

3. **Integrate Git with Jenkins**

   * Connect your private repository to Jenkins using a **personal access token**.

4. **Add Sample Code**

   * Create a new file (`index.js` or `main.py`) inside your repository.
   * Add some basic logic or functionality to this file.

---

### **Part 2: Deploy and Configure SonarQube**

5. **Deploy SonarQube via Docker**

   * Run SonarQube in a Docker container on your host.
   * Configure a **persistent volume** for SonarQube data.

6. **Configure SonarQube Plugin in Jenkins**

   * Install and configure the SonarQube plugin within Jenkins.

7. **Create a New Project in SonarQube**

   * Set up a new project for your repository in SonarQube.
   * **Skip creating a GitHub webhook** — we will use a manual pipeline "Build Now".

8. **Integrate SonarQube with Jenkins**

   * Connect your SonarQube project to your Jenkins pipeline using a **token**.

---

### **Part 3: Analyze Your Code**

9. **Create Jenkins Pipeline for SonarScanner**

   * Configure a pipeline that automatically sends your `index.js` (or `main.py`) file to **SonarScanner**.

10. **Check the Results**

    * Review the analysis results in the SonarQube dashboard.
    * Identify any code smells, bugs, or vulnerabilities.

---

✅ **Tips for Success:**

* All Docker containers should have proper persistent volumes.
* Use tokens for Git and SonarQube integrations instead of webhooks.
* Test the pipeline with a small code change to confirm automatic analysis.