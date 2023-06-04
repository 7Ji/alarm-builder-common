should_build() { 
  # should be called inside the folder
  # #1 pkg name
  # $dir_pkg_absolute must be set by outer function
  local build_pkg=$1
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
    pkgfiles=()
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
      pkgfilename="${i}-${pkgver}-${pkgrel}-aarch64${PKGEXT}"
      pkgfile="${dir_pkg_absolute}/${pkgfilename}"
      if [[ -f "${pkgfile}" ]]; then
        pkgfiles+=("${pkgfile}")
      else
        echo "  -> ${pkgfilename} provided by ${1} not found in built packages, should build ${1}"
        exit 0
      fi
      # fi
    done
    for pkgfile in "${pkgfiles[@]}"; do
      chmod -x "${pkgfile}"
    done
    echo "  -> All package files existing for ${1}, can be skipped"
    exit 1
  )
  return $?
}