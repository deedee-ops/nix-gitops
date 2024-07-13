set -e

LOCAL_PATH="$(git rev-parse --show-toplevel 2> /dev/null || echo '.')"
REMOTE_PATH="github:deedee-ops/nix-gitops"

if [ -n "${LOCAL_PATH}" ] && [ -f "${LOCAL_PATH}/flake.nix" ]; then
  FLAKE_PATH="${LOCAL_PATH}"
else
  FLAKE_PATH="${REMOTE_PATH}"
fi

USERNAME="$(id -un)"
SYSTEM_HOSTNAME="$(hostname -s 2> /dev/null || cat /etc/hostname)"
DEFAULT_HOST="${USERNAME}@${SYSTEM_HOSTNAME}"
PLATFORM="home"

if which nixos-rebuild > /dev/null 2>&1; then
  PLATFORM="nixos"
fi

case "${PLATFORM}" in
  "nixos")
    sudo bash -c "nixos-rebuild switch --flake ${FLAKE_PATH}#${SYSTEM_HOSTNAME}"
  ;;
  "home")
    bash -c "nix run --experimental-features 'nix-command flakes' github:nix-community/home-manager --no-write-lock-file -- switch --flake ${FLAKE_PATH}#${DEFAULT_HOST} --impure"
  ;;
  *)
    echo "invalid platform"
    exit 1
esac
