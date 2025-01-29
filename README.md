# Deepseek-r1-deploy-on-ec2
Deploy Deepseek's r-1 model on AWS with terraform
help you deploy **DeepSeek-R1-14B** on **Amazon EC2** using **Terraform**. The setup will include:

✅ **Provisioning an EC2 instance** (with a GPU)✅ 
**Installing necessary dependencies** (NVIDIA drivers, Docker, Ollama)✅ 
**Deploying the DeepSeek model**✅ 
**Exposing the model through a web UI**

### **Steps to be performed**

1.  **Create an IAM Role** with necessary permissions.
    
2.  **Provision an EC2 instance** with GPU support (g4dn.xlarge or similar).
    
3.  **Install NVIDIA Drivers, Docker, and Ollama** via **User Data**.
    
4.  **Expose the model** using a **security group** (open port 11434 for API access).
    
5.  **Use an Elastic IP** for a stable public address.
    

### **Terraform Steps**

1.  **Terraform script** : to perform the steps mentioned above using terraform refer main.tf (If necessary configure variables.tf and output.tf based on your requirement).
    
2.  **Ensure terraform and aws cli is installed** also ensure to configure aws with appropriate key.
    
3.  **Intialize, Plan and run terraform script**.
    
4.  **The model will now be exposed on the EIP** at port 3000.
    
5.  **Use the UI to interact** with your deployed model.