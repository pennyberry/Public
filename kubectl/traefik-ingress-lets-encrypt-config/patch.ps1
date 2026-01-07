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
kubectl patch deployment traefik -n kube-system --type='strategic' -p $patch