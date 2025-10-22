# Copyright (c) 2022, 2024 Oracle Corporation and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl

data "template_file" "keycloak_yaml" {
  template = file("${path.module}/keycloak.yaml.tpl")

  vars = {
    keycloak_user     = var.keycloak_user
    keycloak_password = var.keycloak_password
  }
}

resource "local_file" "rendered_keycloak_yaml" {
  content  = data.template_file.keycloak_yaml.rendered
  filename = "${path.module}/keycloak.yaml"
}

resource "null_resource" "helm_deployment_via_operator" {
  count = var.deploy_from_operator ? 1 : 0

  triggers = {
    # manifest_md5    = try(md5("${var.helm_template_values_override}-${var.helm_user_values_override}"), null)
    bastion_host    = var.bastion_host
    bastion_user    = var.bastion_user
    ssh_private_key = var.ssh_private_key
    operator_host   = var.operator_host
    operator_user   = var.operator_user
  }

  connection {
    bastion_host        = self.triggers.bastion_host
    bastion_user        = self.triggers.bastion_user
    bastion_private_key = self.triggers.ssh_private_key
    host                = self.triggers.operator_host
    user                = self.triggers.operator_user
    private_key         = self.triggers.ssh_private_key
    timeout             = "40m"
    type                = "ssh"
  }

  

  provisioner "remote-exec" {
    inline = [
      "mkdir -p /home/${var.operator_user}/keycloak"
    ]
  }
  
    provisioner "file" {
    source     = "${path.module}/keycloak.yaml"
    destination = "/home/${var.operator_user}/keycloak/keycloak.yaml"
  }

provisioner "remote-exec" {
  inline = [
    # Apply the Keycloak manifests
    "kubectl apply -f /home/${var.operator_user}/keycloak/keycloak.yaml",

    # Wait for the LoadBalancer IP to appear (timeout ~10 minutes)
    "echo 'Waiting for Keycloak LoadBalancer external IP...'",
    "for i in {1..60}; do",
    "  IP=$(kubectl get svc keycloak -o jsonpath='{.status.loadBalancer.ingress[0].ip}' 2>/dev/null);",
    "  if [ ! -z \"$IP\" ]; then",
    "    echo \"******** Keycloak URL: http://$IP:8080 ********\";",
    "    exit 0;",
    "  fi;",
    "  sleep 10;",
    "done;",
    "echo 'Timeout waiting for LoadBalancer IP after 10 minutes'; exit 1"
  ]
}

  lifecycle {
    ignore_changes = [
      triggers["namespace"],
      triggers["bastion_host"],
      triggers["bastion_user"],
      triggers["ssh_private_key"],
      triggers["operator_host"],
      triggers["operator_user"]
    ]
  }
}
