$namespace = "default"
$pods = (kubectl get deployments -n $namespace -o jsonpath='{.items[*].metadata.name}').split(" ")
$pods | foreach {

  #do
  kubectl annotate deployment $_ -n $namespace keel.sh/policy=all
  kubectl annotate deployment $_ -n $namespace keel.sh/policy=force
  kubectl annotate deployment $_ -n $namespace keel.sh/trigger=poll      
  kubectl annotate deployment $_ -n $namespace keel.sh/pollSchedule="@every 10m"

  #undo
  # kubectl annotate deployment $_ -n $namespace keel.sh/policy-
  # kubectl annotate deployment $_ -n $namespace keel.sh/policy-
  # kubectl annotate deployment $_ -n $namespace keel.sh/trigger-
  # kubectl annotate deployment $_ -n $namespace keel.sh/pollSchedule-
}