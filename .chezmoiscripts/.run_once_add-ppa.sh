readonly UBUNTU_VERSION="$(lsb_release -cs)"

[ -n "$UBUNTU_VERSION" ] || exit $?

{
  echo 'jonathonf vim'
  echo 'git-core ppa'
  echo 'savoury1 gpg'
# echo 'llvm toolchain'
} | while read author ppa ; do
  key_id="$(wget https://api.staging.launchpad.net/1.0/~${author}/+archive/ubuntu/${ppa} -O- | sed -r 's%^(.*" *,)? *"signing_key_fingerprint" *: *"([[:alnum:]]+)".*%\2%')"
  key_name="${author}-${ppa}-key.gpg"
  gpg --no-default-keyring --keyring "./$key_name" --recv-keys --keyserver https://keyserver.ubuntu.com "${key_id:?}
"
  file "./$key_name" | grep -q 'GPG' || { echo 'Failed' ; exit 1 ; } # should be "GPG keybox ..."

  keyring_path="/usr/share/keyrings/$key_name"
  sudo mv "./$key_name" "$keyring_path" || exit $?

  ppa_define_content="[signed-by=${keyring_path}] https://ppa.launchpad.net/${author}/${ppa}/ubuntu $UBUNTU_VERSION main"
  {
    echo "deb $ppa_define_content"
    echo "# deb-src $ppa_define_content"
  } | sudo cat > "/etc/apt/sources.list.d/${author}-${ppa}-ubuntu-${UBUNTU_VERSION}.list"
done

