window_ids=()
menu_args=()

# @tsv emits one tab-separated line per window with any tabs/newlines inside
# fields escaped, so titles are parsed as data rather than re-evaluated as shell.
while IFS=$'\t' read -r id app_id title; do
  window_ids+=("$id")
  # fuzzel dmenu entry: "<label>\0icon\x1f<icon-name>"
  menu_args+=("$app_id" "$title" "$app_id")
done < <(niri msg --json windows | jq -r '.[] | [.id, .app_id, .title] | @tsv')

result=$(printf '%s - %s\0icon\x1f%s\n' "${menu_args[@]}" | fuzzel -w100 --counter --dmenu --index)

if [ "$result" != "" ] && [ "$result" != -1 ]; then
  niri msg action focus-window --id "${window_ids[result]}"
fi
