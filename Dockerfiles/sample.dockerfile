# For building linux runtimecore
# Clang version:9.0.0
FROM centos/devtoolset-4-toolchain-centos7
USER root
RUN yum -y update && \
  yum -y install \
  make \
  fontconfig-devel \
  freetype-devel \
  mesa-libGL-devel \
  pax \
  wget && \
  yum clean all
