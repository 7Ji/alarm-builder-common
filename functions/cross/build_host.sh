relative_source ../prepare/prepare_pkg/should_build.sh

build_host() {
  echo " => Building host part for cross build packages"
  if [[ -d "${dir_build_cross}" ]]; then
    local dir_build_absolute="$(readlink -f ${dir_build})"
    local dir_pkg_absolute="$(readlink -f "${dir_pkg}")"
    local cross_prefix=$(readlink -f ${dir_cross}/xtools_aarch64_on_x86_64)/aarch64-unknown-linux-gnu/bin/aarch64-unknown-linux-gnu-
    pushd "${dir_build_cross}" > /dev/null
    local build_pkg=
    local threads=$(($(nproc) + 1))
    local should_build_pkg=
    for build_pkg in *; do
      if [[ -d "${build_pkg}" ]]; then
        dir_build_pkg="${dir_build_absolute}/${build_pkg}"
        if [[ -d "${dir_build_pkg}" ]]; then
          pushd "${dir_build_pkg}" > /dev/null
          if should_build "${build_pkg}"; then
            should_build_pkg='yes'
          else
            should_build_pkg=''
          fi
          popd > /dev/null
          if [[ "${should_build_pkg}" ]]; then
            pushd "${build_pkg}" > /dev/null
            (
              export ARCH=arm64
              export CROSS_COMPILE="${cross_prefix}"
              export MAKEFLAGS="${MAKEFLAGS} ARCH=${ARCH} CROSS_COMPILE=${CROSS_COMPILE} -j${threads}"
              . build.sh
            )
            popd > /dev/null
          fi
        else
          echo "  -> Ignored cross package ${build_pkg} since we did no find its generic counterpart under ${dir_build}"
        fi
      fi
    done
    popd > /dev/null
  fi
  echo " => Built all host parts for cross build packages"
}