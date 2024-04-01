## Overview:

1.  Setup Azure Resources
2.  Infrastructure as code integration
3.  Container Deployment
4.  Container Instance Configuration(Optional)
5.  Verification and Validation
6.  Conclusion

## introduction

This guide outlines the steps for deploying OneBusAway (OBA) on Microsoft Azure, leveraging containerization for scalability and security. The guide assumes a basic understanding of cloud computing concepts and an existing Azure account. If you haven't created an Azure account yet, refer to the official documentation for instructions: https://learn.microsoft.com/en-us/azure/

# Prerequisite

- An active Azure account with permission to create and manage resources.
- Basic knowledge on cloud computing principles
- An understanding of the Infrastructure as Code (IaC) artifacts created in the associated project.

### How to deploy

# 1\. Setup Azure Resources:

## 1.1 Resources Group Creation:

- You are advised to create a resource group to organize your OBA deployment's Azure resources. Resource groups simplify managemnet and billing.

### Steps:

(Refer to the Azure documentation for for detailed instructions:)  
1\. Login to the Azure [Portal](https://azure.microsoft.com/en-us/get-started/azure-portal)  
2\. Navigate to `Resource groups`  
3\. Click `Create` and provide a descriptive name for your group ( e.g `OBA-deployment`).  
4\. Select a location. You are advised to select a location near you putting into consideration factors such as latency and regulatory requirements.

## 1.2 Container Registry Creation:

- You will be required to create an `Azure Container Registry(ACR)` to store your containerized OBA image.
- ACR acts as a private Docker registry for managing container deployments.

### Steps:

(Refer to Azure docs for detailed instructions)

- Within your resource group, navigate to `Create` -> `Conatiners` -> `Azure Container Registry`.
- Provide a descriptive name for your ACR(e.g `OBA-acr`)
- Select a resource group and location for your ACR.

## 1.3 Virtual Network Creation:

- A virtual network (VNet) is required to define a dedicated network space for your OBA deployment within Azure.
- VNets offer isolation and security benefits.

### Steps:

(Refer to Azure docs for detailed instructions)  
1\. Within your resource group, navigate to `Create` -> `Networking` -> `Virtual network`.  
2\. Provide a descriptive name for your VNet(e.g `OBA-vnet`).  
3\. Select an address space (CIDR block) that accommodates your deployment needs.  
4\. Create subnets within the VNet for further segmentation of your network, this is optional.

## 1.4 Container Instance Provisioning:

- Provision Azure Container Instances (ACIs) to host your containerized OBA application.
- ACIs provide a server less approach to container deployment.

### steps:

(Refer to Azure docs for detailed instructions)

- Within your resources group, navigate to `Create` -> `Containers`\->`Azure Container Instances`.
- Configure the ACI based on your OBA's resources requirements(CPU, memory, etc.)
- Provide a descriptive name for your ACI (e.g, `OBA-aci`).
- Link your ACI to your ACR containing the OBAS container image.

# 2\. Infrastructure as Code(Iac) integration

- The guide should integrate with the IaC artifacts.
- These artifacts likely automate resource provisioning and configuration in azure, streamlining the deployment process.
- The IaC artifacts are provided in a separate file.

## steps (assuming IaC uses tools like ARM templates or Azure Resource Manager)

- Obtain the Iac artifacts from the relevant project repository.
- Review the IaC code ensuring it aligns with your deployment requirements
- Deploy the IaC artifacts using the appropriate Azure tools(e.g Azure CLI, Azure PowerShell).

# 3\. Container Deployment

- Push your containerized OBA image to the Azure Container Registry (ACR) created earlier

## steps:

(Refer to Docker documentation for detailed instructions)  
1\. Tag your OBA container image with the appropriate ACR login server address and image format(e.g. `<acr-name>.azurecr.io/onebusaway:latest`)  
2\. Use the `docker push` command to push the tagged image to your ACR.

# 4\. Container Instance Configuration(Optional)

- If You never used the IaC to configure your ACI, you can perform additional configurations directly in the Azure portal.

### considerations:

1.  **Environment variables**: Set the environment variables within the ACI to provide configuration options for your OBA deployment(e.g database connection details).
2.  **Port mapping**: Map ports on the ACI to expose your OBA application externally if necessary.
3.  **Monitoring and logging**: Configure monitoring and logging solutions for your ACI to track resource utilization and application health.

# 5\. Verification and Validation

- Once the deployment process is complete, verrify that your OBA application is running successfully within the ACI.

### steps:

1.  Access the public IP address or any configured domain name associated with your ACI to to reach the deployed OBA application.
2.  Perform basic functionality tests to ensure OBA is functioning as expected.

# 6\. Conclusion

- By following these steps and intergrating the IaC artifacts, you can deploy OneBusAway on Microsoft Azure in a secure and scalable manner. Remember to refer refer to the respective Azure and Docker documentations for the most up-to-date instructions and detailed configuration options.