#!/bin/zsh
ON='Y'
OFF='N'
FREQ='3s'

while (true) do
   NVIDIA=$( (lspci -k | grep nvidia > /dev/null && echo $ON) || echo $OFF )
   BLUE_AUDIO=$( (pactl list | grep a2dp > /dev/null && echo $ON) || echo $OFF )

   FAN_SPEED=$(grep -m1 level < /proc/acpi/ibm/fan | awk '{print $2}')
   BATT_DRAIN=$(echo "scale=2; $(< /sys/devices/platform/smapi/BAT0/power_now)/1000" | bc)
   BATT_PERCENT=$(< /sys/devices/platform/smapi/BAT0/remaining_percent)
   BATT_DRAIN2=$(echo "scale=2; $(< /sys/devices/platform/smapi/BAT1/power_now)/1000" | bc)
   BATT_PERCENT2=$(< /sys/devices/platform/smapi/BAT1/remaining_percent)

   echo "nvidia: $NVIDIA ~ bluez: $BLUE_AUDIO ~ fans: $FAN_SPEED ~ Bat: $BATT_DRAIN|$BATT_PERCENT% ~ Bat2: $BATT_DRAIN2|$BATT_PERCENT2%"

   sleep $FREQ
done
