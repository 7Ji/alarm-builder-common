relative_source cross/bootstrap.sh
relative_source cross/packages.sh
relative_source cross/in_and_out.sh

cross() {
  echo "=> Cross build starts at $(date) <="
  mkdir -p "${dir_cross}"
  bootstrap
  packages
  in_and_out
  echo "=> Cross build ends at $(date) <="
}