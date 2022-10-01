#!/usr/bin/env bash

search_dir=source/backend
for entry in "$search_dir"/*
do
          path="./$entry"
          app_name=$(basename $path)
          cd "$path"
          
          echo "Building and Deploying $app_name"
          echo "GITHUB SHA $GITHUB_SHA"
          echo "GITHUB REF $GITHUB_REF"

          # build the app
          docker build --tag "gcr.io/khisoft/$app_name:$GITHUB_SHA" --build-arg GITHUB_SHA="$GITHUB_SHA" --build-arg GITHUB_REF="$GITHUB_REF" .
          echo "Build Done"

          # push the app
          docker push "gcr.io/khisoft/$app_name:$GITHUB_SHA"
          echo "Push Done"
          
          # set up kustomize 
          curl -sfLo kustomize https://github.com/kubernetes-sigs/kustomize/releases/download/v3.1.0/kustomize_3.1.0_linux_amd64
          chmod u+x ./kustomize
          echo "Setup Kustomize Done"

          ./kustomize edit set image gcr.io/PROJECT_ID/IMAGE:TAG=gcr.io/khisoft/$app_name:$GITHUB_SHA
          ./kustomize build . | kubectl apply -f -
          kubectl rollout status deployment/staging
          kubectl get services -o wide 
          echo "Deploy Done"

          cd ../../../
done

