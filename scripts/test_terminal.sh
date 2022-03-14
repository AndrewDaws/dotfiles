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

# Bold
print_stage "Testing Bold"
print_step "The following text should be bolded:" "$(echo -e "\e[1mbold\e[0m")"

# Italic
print_stage "Testing Italic"
print_step "The following text should be italicized:" "$(echo -e "\e[3mitalic\e[0m")"

# Bold Italic
print_stage "Testing Bold Italic"
print_step "The following text should be bold and italicized:" "$(echo -e "\e[3m\e[1mbold italic\e[0m")"

# Underline
print_stage "Testing Underline"
print_step "The following text should be underlined:" "$(echo -e "\e[4munderline\e[0m")"

# Double Underline
print_stage "Testing Double Underline"
print_step "The following text should be double underlined:" "$(echo -e "\e[21mdouble underline\e[0m")"

# Undercurl
print_stage "Testing Undercurl"
print_step "The following text should be curly underlined:" "$(echo -e "\e[60mcurly underline\e[0m")"

# Dot Underline
print_stage "Testing Dot Underline"
print_step "The following text should be dot underlined:" "$(echo -e "\e[61mdot underline\e[0m")"

# Dash Underline
print_stage "Testing Dash Underline"
print_step "The following text should be dash underlined:" "$(echo -e "\e[62mdash underline\e[0m")"

# Strikethrough
print_stage "Testing Strikethrough"
print_step "The following text should be struckthrough:" "$(echo -e "\e[9mstrikethrough\e[0m")"

# Dim
print_stage "Testing Dim"
print_step "The following text should be dimmed:" "$(echo -e "\e[2mdim\e[0m")"

# Invert
print_stage "Testing Invert"
print_step "The following text should be inverted:" "$(echo -e "\e[7minvert\e[0m")"

# Hidden
print_stage "Testing Hidden"
print_step "The following text should be blank:" "$(echo -e "\e[8mhidden\e[0m")"

# Blink
print_stage "Testing Blink"
print_step "The following text should be blinking:" "$(echo -e "\e[5mblink\e[0m")"

# True Color
print_stage "Testing True Color"
print_step "The following bar should be a smooth color gradient:" "$(
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

# # Extended
# print_stage "Testing Extended"
# print_step "The following should show different forground, background, and effect text combinations:$(
#   counter="0"
#   printf "\n"
#   for attribute in $(seq 0 12); do
#     for color in $(seq 30 37) $(seq 40 47) $(seq 90 97); do
#       printf %b " ${attribute}/${color}:\033[${attribute};${color}mTesting\033[m"
#       counter="$((counter + 1))"
#       if ((counter % 12 == 0)); then
#         printf "\n"
#       fi
#     done
#   done
# )"
