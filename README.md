# gcp-with-terraform
gcp-with-terraform
# Build kubertates cluster using terraform and deploy simple web app   🌐
using GCP

## terraform resources :

  - vpc 
  - 2 private subnets managment for (VM) && restirected for (cluster)
  - private VM 
  - private cluster 
  - service account 
  - firewall to allow IAP to VM
  - NAT in managment subnet 
  #### Architecture description 
  - cluster dont have accses to egress or ingress
  - only VM can access our cluster 
  - VM access only form IAP 
  - VM cat access internet throw NAT  
  - store app images into GCR that lets cluster to access them 
# Implementation instructions
 -  1- Run terraform code to build infrastructure
 -  2- Configure VM to interact with cluster 
 -  3- Build application images and push them to GRC
 -  4- apply deployment using kubectl
 -  5- create ingress to access our app 

# Run terraform command into terraform Dir
First change project_ID and srvice account 
Then run :
```bash
$ terraform init 
$ terraform plan 
$ terraform apply -auto-approve
```

# configure VM :
1- Connect to VM using console OR from your machine using this command :

```bash
$ gcloud  compute ssh --zone "us-central1-a" "private-vm"  --tunnel-through-iap --project "PROJECT_NAME"
```
2- Copy deployment file into vm 

3- Run the following command to setup enviroment :

```bash
$ sudo apt update
$ sudo apt install kubectl
$ curl -fsSL https://test.docker.com -o test-docker.sh
$ sudo sh test-docker.sh
$ sudo usermod -aG docker ${USER}
$ gcloud auth configure-docker
#restart VM to cofigure changes 
$ gcloud auth login
```

# Build Application  images 
If you want deploy your own application it's up to you OR  [using the Dockerfile that in application dir to buid your custom image](https://github.com/Moatazxz/gcp-gke-cluster-project/tree/main/application)

if you want use this application image i built the image and push it into dockerHub
- use this command to pull application image and Redis  :

```bash
$ docker pull moatazxz/webapp:latest
$ docker pull redis
```
#### push images into GCR

```bash
$ docker pull gcr.io/project-for-gcp-368920/myimage:latest
$ docker pull redis
$ docker tag myimage gcr.io/PROJECT_NAME/myimage
$ docker tag redis  gcr.io/PROJECT_NAME/redis
$ docker push gcr.io/PROJECT_NAME/webapp
$ docker push gcr.io/PROJECT_NAME/redis
```
# Apply deployment 
First if you will use same deployment file dont forget to change image name in yaml file to your image name  
- connect to your cluster using this command: 
 
```bash
$ gcloud compute ssh --zone "asia-east1-a" "private-vm"  --tunnel-through-iap --project "project-for-gcp-368920"
```

- deploy the application using this command 

```bash
#deploy redis deployment  
$ kubectl apply -f redis-deployment.yaml
# deploy clusterIP service 
$ kubectl apply -f clusterip-service.yaml
#deploy application deployment
$ kubectl apply -f myapp-deployment.yaml
```

# create ingress to access  application externaly
- first  create Node port
 
 
```bash
$ kubectl apply -f naodeport.yaml
```

- then create ingress 

 
```bash
$ kubectl apply -f ingress.yaml
```

- using this command to show ingress external IP or loadbalancer

```bash
$ kubectl get ingress
```
##### copy IP into your browser 

# Unfortunately there is an error, I have tried a lot but it is useless (CrashLoopBackOff)
![Screenshot from 2022-11-18 05-57-06](https://user-images.githubusercontent.com/43217520/202614833-ab4fb0c7-e517-44d7-9101-aa28d0937dd6.png)



# cluster view  
![Screenshot from 2022-11-18 05-54-31](https://user-images.githubusercontent.com/43217520/202614824-c2415c94-fe86-4d76-b6ac-2ea5215a746a.png)





# VM terminal view 
![Screenshot from 2022-11-18 05-57-27](https://user-images.githubusercontent.com/43217520/202614835-b9d4128b-3bae-4881-82ff-99a61523c944.png)




# Loadbalance view
![Screenshot from 2022-11-18 06-04-37](https://user-images.githubusercontent.com/43217520/202614842-fd0740b9-22ac-4cc7-b3c5-6da6cfaeceb6.png)



# cluster noed and vm 
![Screenshot from 2022-11-18 05-54-52](https://user-images.githubusercontent.com/43217520/202614826-fa5351ee-c392-4055-95af-9ac90a1daa22.png)
![Screenshot from 2022-11-18 06-05-53](https://user-images.githubusercontent.com/43217520/202614845-20fa5629-b77b-4469-900e-30620ace910a.png)


# GCR
![Screenshot from 2022-11-18 01-28-35](https://user-images.githubusercontent.com/43217520/202614821-3c2368c5-19c1-4e95-90a2-674378ee5a05.png)



# services 

![Screenshot from 2022-11-18 06-07-42](https://user-images.githubusercontent.com/43217520/202614720-d87e9211-ba62-4910-9f4d-b6ee8a8f5338.png)



