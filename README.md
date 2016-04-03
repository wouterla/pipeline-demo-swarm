# pipeline-demo-swarm

Demo project that:
- Creates a delivery pipeline in Jenkins, using Jenkins Job Builder
- Demonstrates running jenkins (and jjb) in local docker containers
- Deploys a demo java project using that pipeline
- Shows a simple dynamic loadbalancer (vulcan) setup implementing blue/green deployment (if you add some tests between blue and green)

It builds from the base in [this project](https://github.com/wouterla/workshop-docker-jenkins) where the readme
contains a lot more help for the basics of docker and jenkins job builder.

Presentation showing the highlights (for previous version based on coreos) can be found on [slideshare](http://www.slideshare.net/wouterla/demo-coreosjenkins)

# Quick start
- Run 'start-swarm.sh' to start a few VMs and consul and swarm on it. Mostly to make sure we can do docker overlay networking stuff, the demo doesn't use much else yet.
- Run 'run_infra_components.sh', which starts etcd and the vulcand loadbalancer
- Run 'run_jenkins.sh', which starts jenkins. access your VMs ip on port 8080 to access jenkins.
- Add my (https://github.com/wouterla/spring-petclinic/)[spring-petclinic] fork as a pipeline project, letting the pipeline script be read from SCM, with the repository url set to https://github.com/wouterla/spring-petclinic/
- Run it!

Oh, and add petclinic.test and petclinic.production to your hosts file (for the VMs IP), 'cause I've set vulcan up to distinguish between environments based on hostname. Then access (http://petclinic.test:8181)[http://petclinic.test:8181] and (http://petclinic.production:8181)[http://petclinic.production:8181] to see exactly the same application runnning! 
