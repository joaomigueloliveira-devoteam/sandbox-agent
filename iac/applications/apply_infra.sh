#!/bin/bash
project_poc=qlf-ai-dev
project_internal=poc-lamp

cd env

# for env in dev prod; do
for env in poc; do

        id=project_$env
        gcloud config set project "${!id}"


        terraform init -backend-config="${env}.backend" -reconfigure
        terraform plan -out="tf.plan" -var-file="${env}.tfvars.json"

        while true; do
        read -p "Apply plan to ${env} project? " ans
        case $ans in
                [Yy]* )
                        terraform apply "tf.plan" &&
                        break
                        ;;
                [Nn]* )
                        break
                        ;;
                * )
                        echo "Choose Y or N."
                        ;;
        esac
        done
done
