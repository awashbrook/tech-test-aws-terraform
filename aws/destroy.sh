#!/bin/sh -x

terraform plan -destroy -out=destroy.tf.plan && terraform apply destroy.tf.plan