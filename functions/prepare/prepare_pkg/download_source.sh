relative_source should_build.sh
download_source() {
  echo " => Downloading source before build"
  local LIBRARY="${LIBRARY:-'/usr/share/makepkg'}"
  local SRCDEST=.
  local lib=
  (
    for lib in "$LIBRARY"/*.sh; do
      source "$lib"
    done
    load_makepkg_config
    pushd "${dir_build}" > /dev/null
    local dir_pkg_absolute="$(readlink -f "${dir_pkg}")"
    local build_pkg=
    for build_pkg in *; do
      if [[ -d "${build_pkg}" ]]; then
        pushd "${build_pkg}" > /dev/null
        if should_build "${build_pkg}"; then
          echo "  -> Downloading source for ${build_pkg} before build.."
          (
            source_safe PKGBUILD
            download_sources novcs allarch
          )
        fi
        popd > /dev/null
      fi
    done
    popd > /dev/null
  )
  echo " => Downloaded all sources before build"
}