# Chef Provisioning AWS Demo

Provision a few web servers in a region with a load balancer

## Web servers

Machines with a simple single-JAR Java webapp that listens on port 
8080. Installs the JVM, Python, supervisord and the simple Java app. 

## Load balancer

Listens on port 80, maps to 8080 on internal instances with all AZs
mapped to the ELB

### Simple webapp

Pre-compiled fat JAR with all dependencies for Java 7+ is included 
in the cookbook for ease of deployment. If you need to make changes, 
the source for it is in src/ and then the JAR is build with Maven using
the package target.
