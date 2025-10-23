# Keycloak demo

## Getting started

This stack will deploys an OKE cluster with one nodepool with one worker node to demonstrate how Keycloak works in OKE in OCI.
In addition it will deploy 2 VM's, a bastion and an operator to be able to manage the cluster.
Do not use in production!

## How to deploy?

### Prerequisites

- You should have an Active Directory setup, either on-premises with a site-to-site/fastconnect in place, or you can deploy a testing AD on a VCN and use Local Peering Gateway to connect it to the OKE VCN to simulate an on-premises AD environment.


**Deploy the Stack:**

    Click the button below to deploy the stack to OCI:

    [![Deploy to OCI](https://docs.oracle.com/en-us/iaas/Content/Resources/Images/deploy-to-oracle-cloud.svg)](https://cloud.oracle.com/resourcemanager/stacks/create?zipUrl=https://github.com/guido-orcl/keycloak-oke/archive/refs/heads/main.zip)


## how to run the demo

- In the stack output you will see: ******** Keycloak URL: http://<<LoadBalancerIP>>:8080 ******** open that URL in a browser
- Use the admin username and password you've set in the Resource Manager (default is admin/admin)
- Follow the official [Keycloak documentation to add your Active Directory Realm](https://www.keycloak.org/docs/latest/server_admin/index.html#_ldap).

## Destroy the OKE cluster

- After you're done testing, from Resource Manager chose the stack you created and click on Destroy button
