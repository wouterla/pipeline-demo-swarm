# pipeline-demo-swarm

Demo project that:
- Creates a delivery pipeline in Jenkins, using Jenkins Job Builder
- Demonstrates running jenkins (and jjb) in local docker containers
- Deploys a demo java project using that pipeline
- Shows a simple dynamic loadbalancer (vulcan) setup implementing blue/green deployment (if you add some tests between blue and green)

It builds from the base in [this project](https://github.com/wouterla/workshop-docker-jenkins) where the readme
contains a lot more help for the basics of docker and jenkins job builder.

Presentation showing the highlights (for previous version based on coreos) can be found on [slideshare](http://www.slideshare.net/wouterla/demo-coreosjenkins)
