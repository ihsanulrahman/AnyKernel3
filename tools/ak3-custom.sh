### AnyKernel custom methods
## dereference23@github.com
## Karan-Frost@github.com
## ihsanulrahman@github.com

check_ksu() {
  # Always extract images first
  7za x $AKHOME/Images.7z -o"$AKHOME/"

  # Initialize selection variables
  local selection=1
  local choice=""
  local key_selected=0

  # Volume Key Selection
  ui_print "==============================================="
  ui_print "         VOLUME KEY SELECTION MODE"
  ui_print "==============================================="
  ui_print " "
  ui_print "USE VOLUME + TO CYCLE, VOLUME - TO SELECT"
  ui_print "TIMEOUT: 15 SECONDS"
  ui_print " "
  ui_print "1. NON-KSU (DEFAULT)"
  ui_print "2. KSU"
  ui_print " "
  ui_print "CURRENT SELECTION: NON-KSU"

  local start_time=$(date +%s)
  local timeout=15

  while true; do
    local keyevent=$(getevent -lc 1 2>/dev/null | grep "KEY_" | head -n 1 | awk '{print $3}')
    local now=$(date +%s)
    local elapsed=$((now - start_time))

    if [ "$elapsed" -ge "$timeout" ]; then
      ui_print "TIMEOUT REACHED. USING FALLBACK METHOD."
      break
    fi

    case "$keyevent" in
    KEY_VOLUMEUP)
      selection=$((selection % 2 + 1))
      case $selection in
        1) ui_print "CURRENT SELECTION: NON-KSU" ;;
        2) ui_print "CURRENT SELECTION: KSU" ;;
      esac
      start_time=$(date +%s)
      sleep 0.5
      ;;
    KEY_VOLUMEDOWN)
      key_selected=1
      case $selection in
        1)
          ui_print "SELECTED: NON-KSU"
          choice="nonksu"
          ;;
        2)
          ui_print "SELECTED: KSU"
          choice="ksu"
          ;;
      esac
      break
      ;;
    esac
  done

  # Fallback to file detection if no key selection was made
  if [ "$key_selected" -eq 0 ]; then
    if [ -e $AKHOME/KSU_UNLOCK ]; then
      ui_print " "
      ui_print "Detected KSU_UNLOCK file"
      choice="ksu"
    else
      choice="nonksu"
    fi
  fi

  # Process selection
  case $choice in
    "ksu")
      ui_print " " "Flashing KernelSU version..."
      ui_print "This is not secure!"
      rm -f $AKHOME/Image
      gzip $AKHOME/Image_KSU
      mv $AKHOME/Image_KSU.gz $AKHOME/Image.gz
      ;;
    "nonksu")
      rm -f $AKHOME/Image_KSU
      gzip $AKHOME/Image
      ;;
  esac
}