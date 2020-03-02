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
  yum clean all && \
  wget http://runtimezip.esri.com:8080/userContent/apps-archive/archive/local_system_setup/runtimecore/linux/9.0.0_clang_libc++_x64.tar.gz && \
  tar xzPf 9.0.0_clang_libc++_x64.tar.gz && \
  rm 9.0.0_clang_libc++_x64.tar.gz
