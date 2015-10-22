#! /bin/bash
#
# Sample events script for mcabber
# Plays a sound when receiving a message
#
# To use this script, set the "events_command" option to the path of
# the script (see the mcabberrc.example file for an example)
#
# MiKael, 2005-07-15

# The following sound comes with the gtkboard package,
# you can modify this line to play another one...
CMD_MSG_IN=" play /usr/share/sounds/KDE-Im-Message-Out.ogg"

event=$1
arg1=$2
arg2=$(printf '%q' $3)
filename=$4
# Note that the 4th argument is only provided for incoming messages
# and when 'event_log_files' is set.
echo $1 $2 $3 $4 >> /tmp/log.mac
if [ $event = "MSG" ]; then
  case "$arg1" in
    IN|MUC)
      if [ $arg1 = "IN" ]; then
          $CMD_MSG_IN > /dev/null 2>&1
      fi
      if [ -n "$filename" -a -f "$filename" ]; then
          message=`printf '%q' $(head -n 1 $filename)`
          echo 'naughty.notify({title = "'$arg2'", text = "Send a message on jabber : '$message'", position="bottom_right", bg="#5A58A7", fg="white"})' | awesome-client
          /bin/rm $filename
      fi
      ;;
    OUT)
      # Outgoing message for buddy $arg2
      ;;
  esac
elif [ $event = "STATUS" ]; then
  # Buddy $arg2 status is $arg1 (_, O, I, F, D, N, A)
  echo > /dev/null
elif [ $event = "UNREAD" ]; then
  # $arg1 contains 4 numbers separated with space chars:
  # Nr of unread buffers, nr of unread buffers with attention sign,
  # nr of MUC unread buffers, nr of MUC unread buffers with attention sign.
  echo 'naughty.notify({title = "Unread messages:", text = "'"There are $arg1 new messages."'"})' | awesome-client
fi
