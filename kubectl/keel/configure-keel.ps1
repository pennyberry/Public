$namespace = "default"
$pods = (kubectl get deployments -n $namespace -o jsonpath='{.items[*].metadata.name}').split(" ")
$pods | foreach {

  #do
  kubectl annotate deployment $_ -n $namespace keel.sh/policy=all

  #undo
  # kubectl annotate deployment $_ -n $namespace keel.sh/policy-
}