#!/usr/bin/env bash

echo "[TASK-1] Create Local Binary Directory"
mkdir -p ~/.local/bin/kubectl

echo "[TASK-2] Install kubectl binary"
curl -LO https://dl.k8s.io/release/v1.20.0/bin/linux/amd64/kubectl
mv ./kubectl ~/.local/bin/kubectl
