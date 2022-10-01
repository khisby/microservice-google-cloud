#!/usr/bin/env bash

search_dir=source/backend

for entry in "$search_dir"/*
do
          path="./$entry"
          app_name=$(basename $path)
          tag="gcr.io/$PROJECT_ID/$app_name:$GITHUB_SHA"

          cd "$path"
          
          echo "================= Building and Deploying $app_name ================="
          echo "================= GITHUB SHA $GITHUB_SHA ================="
          echo "================= GITHUB REF $GITHUB_REF ================="

          # copy asset to directory
          cp -r ../../../.github/assets/* .

          # create deployment.yaml
          sed -e "s/{APP_NAME}/$app_name/g" -e "s/{PROJECT_ID}/$PROJECT_ID/g" -e "s/{GITHUB_SHA}/$GITHUB_SHA/g"  deployment.yaml.template > deployment.yaml

          # build the app
          docker build --tag "$tag" --build-arg GITHUB_SHA="$GITHUB_SHA" --build-arg GITHUB_REF="$GITHUB_REF" .
          echo "================= Build Done ================="

          # push the app
          docker push "$tag"
          echo "================= Push Done ================="

          # deployment
          kubectl apply -f deployment.yaml
          kubectl rollout status deployment/"$app_name"
          kubectl get services -o wide 
          echo "================= Deploy Done ================= "

          cd ../../../
done

