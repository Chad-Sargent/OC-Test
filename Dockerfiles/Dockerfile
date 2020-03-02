# For building linux runtimecore
# Clang version:9.0.0
FROM centos/devtoolset-4-toolchain-centos7
USER 0 
RUN yum install -y \
  make \
  fontconfig-devel \
  freetype-devel \
  mesa-libGL-devel \
  pax \
  && yum clean all -y
# non-root user 
USER 1001
