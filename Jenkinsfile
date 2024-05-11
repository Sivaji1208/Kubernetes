

pipeline {    
    environment {
        AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
        AZURE_SUBSCRIPTION_ID = credentials('AZURE_SUBSCRIPTION_ID')
        AZURE_CLIENT_ID = credentials('AZURE_CLIENT_ID')
        AZURE_CLIENT_SECRET = credentials('AZURE_CLIENT_SECRET')
        AZURE_TENANT_ID = credentials('AZURE_TENANT_ID')   
        ARM_ACCESS_KEY = credentials('ARM_ACCESS_KEY')
    }
   agent  any
    stages {
        stage('checkout') {
            steps {
                 script{
                        dir("terraform")
                        {
                            git "https://github.com/RaaviSivajiTech/PetclinicApp.git"
                        }
                    }
                }
            }

        stage('Provisioning by Shell Scripts') {
            when {
                changeset "Azure/Scripts/*"
            }
            steps {
                 withCredentials([azureServicePrincipal('ARM_CRED')]) {
                    
                    sh 'echo "Azure Cluster Infrastructure provisioning started"'
                    
                    sh "pwd;cd Azure/Scripts/; pwd; ls;"

                    sh 'sudo chmod 777 /var/lib/jenkins/workspace/KubernetesCluster/Azure/Scripts/azureinfra.sh'

                    sh '/var/lib/jenkins/workspace/KubernetesCluster/Azure/Scripts/azureinfra.sh;'

                    sh 'echo "Azure Cluster Infrastructure provisioning started"'
                }
            }
        }

        stage('Terraform init_and_plan') {
            when {
                changeset "infra/terraform/*"
            }

            steps {
                dir('infra/terraform') {
                    withCredentials([azureServicePrincipal(credentialsId: 'ARM_CRED',
                                        subscriptionIdVariable: 'AZURE_SUBSCRIPTION_ID',
                                        clientIdVariable: 'AZURE_CLIENT_ID',
                                        clientSecretVariable: 'AZURE_CLIENT_SECRET',
                                        tenantIdVariable: 'AZURE_TENANT_ID'),
                                     azureStorage(credentialsId: 'STORAGEACCESS_KEY',
                                     storageAccountKeyVariable: 'ARM_ACCESS_KEY')]) {
                        sh "terraform init"
                         sh "terraform plan -out=plan -var 'client_id=$AZURE_CLIENT_ID' -var 'client_secret=$AZURE_CLIENT_SECRET'"
                    }
                }
            }
        }      
    }
  }
