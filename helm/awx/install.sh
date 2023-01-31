helm repo add awx-operator https://ansible.github.io/awx-operator/
helm repo update
helm install my-awx-operator awx-operator/awx-operator -n awx --create-namespace