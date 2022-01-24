#!/bin/bash
#
# Terminal capabilities test script

if [[ -f "$(dirname "$(readlink -f "${0}")")/.functions" ]]; then
  # shellcheck disable=SC1090
  # shellcheck disable=SC1091
  source "$(dirname "$(readlink -f "${0}")")/.functions"
else
  echo "File does not exist!"
  echo "  $(dirname "$(readlink -f "${0}")")/.functions"
  exit "1"
fi

# Test Italics
print_stage "Testing Italics"
print_step "The following text should be italicized:" "$(tput sitm)italics$(tput ritm)"

# Test True Color
print_stage "Testing True Color"
print_step "The following bar should show a smooth color gradient:" "$(
  awk 'BEGIN{
    s="/\\/\\/\\/\\/\\"; s=s s s s s s s s s s s s s s s s s s s s s s s;
    for (column_number = 0; column_number < 256; column_number++) {
      r = 255 - (column_number * 255 / 255);
      g = (column_number * 510 / 255);
      b = (column_number * 255 / 255);
      if (g > 255) g = 510 - g;
      printf "\033[48;2;%d;%d;%dm", r, g, b;
      printf "\033[38;2;%d;%d;%dm", 255 - r, 255 - g, 255 - b;
      printf "%s\033[0m", substr(s, column_number + 1, 1);
    }
    printf "\n";
  }'
)"
