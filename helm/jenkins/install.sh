#https://artifacthub.io/packages/helm/jenkinsci/jenkins
helm repo add jenkins https://charts.jenkins.io
helm repo update
helm install jenkins jenkins/jenkins -n jenkins --create-namespace


# pipeline {
#     agent {
#         kubernetes {
#             defaultContainer 'jnlp'
#         }
#     }
#     stages {
#         stage('Hello') {
#             steps {
#                 echo 'Hello everyone! This is now running on a Kubernetes executor!'
#             }
#         }
#     }
# }