
export PATH="/run/current-system/sw/bin:$PATH"

BIN_PACMD="pacmd"
BIN_PACTL="pactl"

STEP="5"

function volumeUp {
  ${BIN_PACTL} set-sink-volume @DEFAULT_SINK@ "+${STEP}%"
}

function volumeDown {
  ${BIN_PACTL} set-sink-volume @DEFAULT_SINK@ "-${STEP}%"
}

function inputMute {
  case "$1" in
    mute)
      ${BIN_PACTL} set-source-mute @DEFAULT_SOURCE@ 1
      ;;
    unmute)
      ${BIN_PACTL} set-source-mute @DEFAULT_SOURCE@ 0
      ;;
  esac
}

function outputMute {
  case "$1" in
    mute)
      ${BIN_PACTL} set-sink-mute @DEFAULT_SINK@ 1
      currentVolume=0
      ;;
    unmute)
      ${BIN_PACTL} set-sink-mute @DEFAULT_SINK@ 0
      getCurrentVolume
      ;;
  esac
}

function getCurrentVolume {
  currentVolume=$(${BIN_PACMD} list-sinks | grep -A 15 '* index:' | grep 'volume:' | grep -E -v 'base volume:' | awk -F : '{print $3}' | grep -o -P '.{0,3}%'| sed s/.$// | tr -d ' ')
}

function getInputMuteStatus {
  inputMuteStatus=$(${BIN_PACMD} list-sources | grep -A 15 '* index:' | awk '/muted/{ print $2 }')
}

function getOutputMuteStatus {
  outputMuteStatus=$(${BIN_PACMD} list-sinks | grep -A 15 '* index:' | awk '/muted/{ print $2 }')
}

function listen {
    firstrun=0

    ${BIN_PACTL} subscribe 2>/dev/null | {
        while true; do
            {
                # If this is the first time just continue
                # and print the current state
                # Otherwise wait for events
                # This is to prevent the module being empty until
                # an event occurs
                if [ $firstrun -eq 0 ]
                then
                    firstrun=1
                else
                    read -r event || break
                    if ! echo "$event" | grep -e "on card" -e "on sink"
                    then
                        # Avoid double events
                        continue
                    fi
                fi
            } &>/dev/null
            output
        done
    }
}

function output {
  getCurrentVolume
  getOutputMuteStatus
  getInputMuteStatus

  if [ "${outputMuteStatus}" = 'yes' ]; then
    outputIcon=""
  else
    outputIcon=""
  fi

  if [ "${inputMuteStatus}" = 'yes' ]; then
    inputIcon=""
  else
    inputIcon=""
  fi

  echo "$inputIcon $outputIcon $currentVolume%"
}

case "$1" in
  --up)
    volumeUp
    ;;
  --down)
    volumeDown
    ;;
  --toggle-input-mute)
    getInputMuteStatus
    if [ "${inputMuteStatus}" = 'yes' ]; then
      inputMute unmute
    else
      inputMute mute
    fi
    ;;
  --toggle-output-mute)
    getOutputMuteStatus
    if [ "${outputMuteStatus}" = 'yes' ]; then
      outputMute unmute
    else
      outputMute mute
    fi
    ;;
  --listen)
    listen
    ;;
  *)
    # keep the default sink
    DEFAULT_SINK="$(${BIN_PACMD} list-sinks | grep alsa_output | awk -F'[<>]' '{print $2}' | grep analog)"
    if [ -z "${DEFAULT_SINK}" ]; then
      DEFAULT_SINK="$(${BIN_PACMD} list-sinks | grep alsa_output | awk -F'[<>]' '{print $2}' | grep hw_0_7)"
      if [ -z "${DEFAULT_SINK}" ]; then
        DEFAULT_SINK="$(${BIN_PACMD} list-sinks | grep alsa_output | awk -F'[<>]' '{print $2}' | grep hdmi)"
        if [ -z "${DEFAULT_SINK}" ]; then
          DEFAULT_SINK="$(${BIN_PACMD} list-sinks | grep alsa_output | awk -F'[<>]' '{print $2}' | head -n 1)"
        fi
      fi
    fi
    ${BIN_PACMD} set-default-sink "${DEFAULT_SINK}"
    output
    ;;
esac
