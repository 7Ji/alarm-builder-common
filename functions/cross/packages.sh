relative_source packages/cross_download_source.sh
relative_source packages/build_host.sh

packages() {
  local dir_build_absolute="$(readlink -f ${dir_build})"
  local dir_pkg_absolute="$(readlink -f "${dir_pkg}")"
  local PKGEXT=.pkg.tar
  cross_download_source
  build_host
}