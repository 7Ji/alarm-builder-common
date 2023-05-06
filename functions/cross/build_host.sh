relative_source ../prepare/prepare_pkg/should_build.sh

build_host() {
  if [[ -d "${dir_build_cross}" ]]; then
    echo " => Building host part for cross build packages"
    pushd "${dir_build_cross}" > /dev/null
    local build_pkg
    local threads=$(($(nproc) + 1))
    for build_pkg in *; do
      if [[ -d "${build_pkg}" ]]; then
        dir_build_pkg="${dir_build}/${build_pkg}"
        if [[ -d "${dir_build_pkg}" ]]; then
          pushd "${dir_build_pkg}" > /dev/null
          if should_build "${build_pkg}"; then
            pushd "${build_pkg}" > /dev/null
            (
              export ARCH=arm64
              export CROSS_COMPILE=aarch64-linux-gnu-
              export PATH="$(readlink -f ${dir_cross}/xtools_aarch64_on_x86_64)/aarch64-unknown-linux-gnu/bin:${PATH}"
              export MAKEFLAGS="${MAKEFLAGS} ARCH=${ARCH} CROSS_COMPILE=${CROSS_COMPILE} -j${threads}"
              . build.sh
            )
            popd > /dev/null
          fi
          popd > /dev/null
        else
          echo "  -> Ignored cross package ${build_pkg} since we did no find its generic counterpart under ${dir_build}"
        fi
      fi
    done
    popd > /dev/null
  fi
  echo " => Built all host parts for cross build packages"
}