kubectl get secret -n awx awx-admin-password -o jsonpath="{.data.password}" | base64 --decode 