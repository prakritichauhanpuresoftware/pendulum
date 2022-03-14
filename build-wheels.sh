#!/bin/bash
set -e -x

cd $(dirname $0)

curl -fsS -o install-poetry.py https://raw.githubusercontent.com/sdispater/poetry/master/install-poetry.py
#rm get-poetry.py

for PYBIN in /opt/python/cp3*/bin; do
  if [ "$PYBIN" == "/opt/python/cp34-cp34m/bin" ]; then
    continue
  fi
  if [ "$PYBIN" == "/opt/python/cp35-cp35m/bin" ]; then
    continue
  fi
  rm -rf build
  export PATH=${PYBIN}:$PATH
  ${PYBIN}/python install-poetry.py --preview -y
  export PATH=/root/.local/bin:$PATH
  poetry build -vvv
done

cd dist
for whl in *.whl; do
    auditwheel repair "$whl"
    rm "$whl"
done
