# shellcheck source=/dev/null

GPU="N/A"

# Detect GPU vendor from the first DRM card
for card in /sys/class/drm/card*; do
  [ -d "$card/device" ] || continue
  DEV="$card/device"

  # --- Intel (sysfs freq ratio) ---
  if [ -f "$card/gt_act_freq_mhz" ]; then
    ACT=$(cat "$card/gt_act_freq_mhz")
    MAX=$(cat "$card/gt_max_freq_mhz")
    GPU="$((ACT * 100 / MAX))%"

  # --- AMD ---
  elif [ -f "$DEV/gpu_busy_percent" ]; then
    GPU="$(cat "$DEV/gpu_busy_percent")%"
  fi

  [ "$GPU" != "N/A" ] && break
done

echo "Gpu: $GPU"
