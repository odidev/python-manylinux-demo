#!/bin/bash
set -e -x

# Install a system package required by our library
sudo yum install -y atlas-devel

# Compile wheels
for PYBIN in /opt/python/*/bin; do
    file /opt/_internal/cpython-*/bin/python*
    cat ${PYBIN}/pip

sudo ${PYBIN}/pip install -r ./dev-requirements.txt
    ${PYBIN}/pip wheel . -w wheelhouse/
done

# Bundle external shared libraries into the wheels
for whl in wheelhouse/*.whl; do
    auditwheel repair $whl -w ./wheelhouse/
done

# Install packages and test
for PYBIN in /opt/python/*/bin/; do
    sudo ${PYBIN}/pip install python-manylinux-demo --no-index -f ./wheelhouse
    (cd $HOME; ${PYBIN}/nosetests pymanylinuxdemo)
done
