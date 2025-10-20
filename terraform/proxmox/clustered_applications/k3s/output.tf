output "server-ip" {
  value = module.k3s_server_node.*.ip[0][0]
}

output "agent-ip" {
  value = module.k3s_agent.*.ip
}

output "Windows_Kubectl_command" {
  value = "$env:KUBECONFIG = '${pathexpand("~/.kube/${module.k3s_server_node.name[0]}.yaml")}'"
}
output "Command_to_Update_IP_on_kube_config_yaml" {
  value = <<-EOT
(get-content ~\.kube\k3s-server.yaml).Replace("127.0.0.1","${module.k3s_server_node.ip[0]}") | set-content ~\.kube\k3s-server.yaml
EOT
}