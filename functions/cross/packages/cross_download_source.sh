relative_source ../../prepare/prepare_pkg/download_source.sh
relative_source ../../prepare/prepare_blob.sh

cross_download_source() {
  echo " => Pre-downloading sources for cross build"
  local arch_root="$(readlink -f ${dir_cross}/aarch64)"
  LIBRARY="${arch_root}/usr/share/makepkg" \
  MAKEPKG_CONF="${arch_root}/etc/makepkg.conf" \
    download_source
  prepare_blob
  echo " => Pre-downloaded sources"
}