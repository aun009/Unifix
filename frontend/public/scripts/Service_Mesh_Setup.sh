#!/bin/bash
set -e
curl -L https://istio.io/downloadIstio | sh -
cd istio-*/bin
export PATH=$PWD:$PATH
istioctl install --set profile=demo -y
