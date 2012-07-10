#! /bin/bash
{
  # Log file, file where we tell what events have been processed.
  LOG_FILE=/var/log/posttorrent.log
  # Username for transmission remote.
#  TR_USERNAME="username"
  # Password for transmission remote.
#  TR_PASSWORD="password"
  # Get current time.
  NOW=$(date +%Y-%m-%d\ %H:%M:%S)
  # Source directory, should not be changed.
  SRC_DIR="${TR_TORRENT_DIR}/${TR_TORRENT_NAME}"
  # Directory to store the un-compressed files in..
  DEST_DIR="/home/pdq/Videos/tempvideo"
  # This parameter string could be passed from Transmission in the future.
  TR_TORRENT_PARAMETER="EXTRACT SLEEP1h"

  if [ -e "$SRC_DIR/keep" ]; then
    TR_TORRENT_PARAMETER="$TR_TORRENT_PARAMETER KEEP"
  fi

  if [ -e "$SRC_DIR/exit" ]; then
    TR_TORRENT_PARAMETER="EXIT"
  fi

  # Actual processing starts here.
  if [[ "$TR_TORRENT_PARAMETER" =~ "EXIT" ]]; then
    echo $NOW "Exiting $TR_TORRENT_NAME" >> $LOG_FILE
    exit 0
  fi

  if [[ "$TR_TORRENT_PARAMETER" =~ "EXTRACT" ]]; then
    cd $TR_TORRENT_DIR
    if [ -d "$SRC_DIR" ]; then
      IFS=$'\n'
      unset RAR_FILES i
      for RAR_FILE in $( find "$SRC_DIR" -iname "*.rar" ); do
        RAR_FILES[i++]=$RAR_FILE
      done
      unset IFS

      if [ ${#RAR_FILES} -gt 0 ]; then
        for RAR_FILE in "${RAR_FILES[@]}"; do
          unrar x -inul "$RAR_FILE" "$DEST_DIR"
        done
        if [[ ! "$TR_TORRENT_PARAMETER" =~ "KEEP" ]]; then
          SLEEP=$(expr match "$TR_TORRENT_PARAMETER" '.*SLEEP\([0-9a-zA-Z]*\)')
          if [ ${#SLEEP} -gt 0 ]; then
            sleep $SLEEP
          fi
          #sudo vlc $DEST_DIR/$TR_TORRENT_NAME.* --playlist-enqueue
          #transmission-remote -n $TR_USERNAME:$TR_PASSWORD -t$TR_TORRENT_ID --remove-and-delete
        fi
        echo $NOW "Unrarred $TR_TORRENT_NAME" >> $LOG_FILE
      fi
    fi
  fi
} &
