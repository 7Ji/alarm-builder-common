move_built_to_pkg() {
  # should be called inside the folder
  # #1 pkg name
  # #2 dir_pkg_absolute
  local build_pkg="$1"
  local dir_pkg_absolute="$2"
  (
    . PKGBUILD
    file_blacklist="../${build_pkg}.blacklist"
    file_whitelist="../${build_pkg}.whitelist"
    if [[ -f "${file_blacklist}" ]]; then
      readarray -t blacklist < "${file_blacklist}"
    else
      blacklist=()
    fi
    if [[ -f "${file_whitelist}" ]]; then
      readarray -t whitelist < "${file_whitelist}"
    else
      whitelist=()
    fi
    if [[ ${arch[0]} == 'any' ]]; then
      local arch_naming='any'
    else
      local arch_naming='aarch64'
    fi
    for i in "${pkgname[@]}"; do
      if [[ "${blacklist}" ]]; then
        should_build='yes'
        for j in "${blacklist[@]}"; do
          if [[ "${j}" == "${i}" ]]; then
            should_build=''
            break
          fi
        done
        if [[ -z "${should_build}" ]]; then
          continue
        fi
      fi
      if [[ "${whitelist}" ]]; then
        should_build=''
        for j in "${whitelist[@]}"; do
          if [[ "${j}" == "${i}" ]]; then
            should_build='yes'
            break
          fi
        done
        if [[ -z "${should_build}" ]]; then
          continue
        fi
      fi
      if [[ $(type -t pkgver) == 'function' ]]; then
        pkgfile_glob1="${i}-"
        pkgfile_glob2="-${pkgrel}-${arch_naming}${PKGEXT}"
        chmod -x "${pkgfile_glob1}"*"${pkgfile_glob2}"
        mv -vf "${pkgfile_glob1}"*"${pkgfile_glob2}" "${dir_pkg_absolute}/"
      else
        pkgfile="${i}-${pkgver}-${pkgrel}-${arch_naming}${PKGEXT}"
        chmod -x "${pkgfile}"
        mv -vf "${pkgfile}" "${dir_pkg_absolute}/"
      fi
    done
  )
}