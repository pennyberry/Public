$patch = @"
{
  "spec": {
    "template": {
      "spec": {
        "volumes": [
          {
            "name": "nfs",
            "persistentVolumeClaim": {
              "claimName": "truenas-pvc2"
            }
          }
        ],
        "containers": [
          {
            "name": "traefik",
            "volumeMounts": [
              {
                "name": "nfs",
                "mountPath": "/data",
                "subPath": "applications/traefik/volumes/data"
              }
            ]
          }
        ]
      }
    }
  }
}
"@


#kubectl get deployment traefik -o jsonpath='{.spec.template.spec.volumes}'
kubectl patch deployment traefik -n kube-system --type='strategic' -p $patch
kubectl patch deployment traefik --type=json -p='[{"op":"remove","path":"/spec/template/spec/volumes/1"}]'
