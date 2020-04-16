#/bin/bash
export BUILD_VERSION=v0.1.2
export DOCKER_REPO=baudekin
export R_VERSION=r3.6.3
export SPARKLYR_VERSION=sparklyr1.1.0_dplyr0.8.5
export PYTHON_VERSION=3.7
docker build --tag ${DOCKER_REPO}/openjdk8_build:${BUILD_VERSION} ./build
docker push ${DOCKER_REPO}/openjdk8_build:${BUILD_VERSION} 
docker build --tag ${DOCKER_REPO}/spark2.4.5_sparkbuild:${BUILD_VERSION} ./sparkbuild
docker push ${DOCKER_REPO}/spark2.4.5_sparkbuild:${BUILD_VERSION} 
docker build --tag ${DOCKER_REPO}/spark2.4.5_sparkapps:${BUILD_VERSION} ./sparkapps
docker push ${DOCKER_REPO}/spark2.4.5_sparkapps:${BUILD_VERSION} 
docker build --tag ${DOCKER_REPO}/spark2.4.5_sparkrbuild_${R_VERSION}:${BUILD_VERSION} ./SparkRbuild
docker push ${DOCKER_REPO}/spark2.4.5_sparkrbuild_${R_VERSION}:${BUILD_VERSION} 
docker build --tag ${DOCKER_REPO}/spark2.4.5_sparkrapps_${R_VERSION}:${BUILD_VERSION} ./SparkRapps
docker push ${DOCKER_REPO}/spark2.4.5_sparkrapps_${R_VERSION}:${BUILD_VERSION} 
docker build --tag ${DOCKER_REPO}/spark2.4.5_sparklyrbuild_${SPARKLYR_VERSION}:${BUILD_VERSION} ./sparklyrbuild
docker push ${DOCKER_REPO}/spark2.4.5_sparklyrbuild_${SPARKLYR_VERSION}:${BUILD_VERSION} 
docker build --tag ${DOCKER_REPO}/spark2.4.5_sparklyrapps_${SPARKLYR_VERSION}:${BUILD_VERSION} ./sparklyrapps
docker push ${DOCKER_REPO}/spark2.4.5_sparklyrapps_${SPARKLYR_VERSION}:${BUILD_VERSION} 
docker build --tag ${DOCKER_REPO}/spark2.4.5_pybuild_${PYTHON_VERSION}:${BUILD_VERSION} ./pybuild
docker push ${DOCKER_REPO}/spark2.4.5_pybuild_${PYTHON_VERSION}:${BUILD_VERSION} 
docker build --tag ${DOCKER_REPO}/spark2.4.5_pyapps_${PYTHON_VERSION}:${BUILD_VERSION} ./pyapps
docker push ${DOCKER_REPO}/spark2.4.5_pyapps_${PYTHON_VERSION}:${BUILD_VERSION} 
docker build --tag ${DOCKER_REPO}/spark2.4.5_pynotebook_${PYTHON_VERSION}:${BUILD_VERSION} ./pynotebook
docker push ${DOCKER_REPO}/spark2.4.5_pynotebook_${PYTHON_VERSION}:${BUILD_VERSION} 
