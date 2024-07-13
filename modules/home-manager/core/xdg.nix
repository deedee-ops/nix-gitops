{ config, ... }: {
  home = {
    sessionVariables = {
      XDG_CONFIG_HOME = "${config.xdg.configHome}";
      XDG_CACHE_HOME = "${config.xdg.cacheHome}";
      XDG_DATA_HOME = "${config.xdg.dataHome}";
      XDG_STATE_HOME = "${config.xdg.stateHome}";

      # Android platform tools
      ANDROID_HOME = "${config.xdg.dataHome}/android";

      # Ansible
      ANSIBLE_HOME = "${config.xdg.configHome}/ansible";
      ANSIBLE_CONFIG = "${config.xdg.configHome}/ansible.cfg";
      ANSIBLE_GALAXY_CACHE_DIR = "${config.xdg.cacheHome}/ansible/galaxy_cache";

      # AWS
      AWS_SHARED_CREDENTIALS_FILE = "${config.xdg.configHome}/aws/credentials";
      AWS_CONFIG_FILE = "${config.xdg.configHome}/aws/config";

      # Docker
      DOCKER_CONFIG = "${config.xdg.configHome}/docker";

      # Go
      GOPATH = "${config.xdg.dataHome}/go";

      # GTK-2.0
      GTK2_RC_FILES = "${config.xdg.configHome}/gtk-2.0/gtkrc";

      # Kubernetes
      KREW_ROOT = "${config.xdg.configHome}/krew";
      KUBECONFIG = "${config.xdg.configHome}/kube/config";
      KUBECACHEDIR = "${config.xdg.cacheHome}/kube";
      TALOSCONFIG = "${config.xdg.configHome}/talos/config";

      # Less
      LESSHISTFILE = "${config.xdg.stateHome}/less/history";

      # NPM
      NPM_CONFIG_USERCONFIG = "${config.xdg.configHome}/npm/npmrc";

      # nVIDIA
      CUDA_CACHE_PATH = "${config.xdg.cacheHome}/nv";

      # Python
      PYTHONSTARTUP = "${config.xdg.configHome}/python/pythonrc";

      # Screen
      SCREENRC = "${config.xdg.configHome}/screen/screenrc";

      # Sqlite3
      SQLITE_HISTORY = "${config.xdg.cacheHome}/sqlite_history";

      # Teleport
      TELEPORT_HOME = "${config.xdg.configHome}/teleport";

      # Terminfo
      TERMINFO = "${config.xdg.dataHome}/terminfo";
      TERMINFO_DIRS = "${config.xdg.dataHome}/terminfo:/usr/share/terminfo";

      # virsh
      LIBVIRT_DEFAULT_URI = "qemu:///system";
    };
  };

  programs.zsh = {
    shellAliases = {
      wget = "wget --hsts-file=${config.xdg.dataHome}/wget-hsts";
    };
  };
}
