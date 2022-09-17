{{- $alias_list := includeTemplate "shell/alias-list" . | fromJson }}
{{- range $alias_list }}
{{-   $depends_list := get . "depends_list"
    | default (list (hasKey . "depends" | ternary . ""))
    | compact
}}
{{-   if empty $depends_list -}}
alias {{ get . "name" }}='{{ get . "command" }}'
{{    else }}
{{-     "\n" }}
{{-     range $index, $depends_info := $depends_list }}
{{-       $depends := get $depends_info "depends" }}
{{-       if $depends }}
{{-         if $index | eq 0 -}}
if
{{-         else -}}
elif
{{-         end }}{{- " " -}}
  [ -n "$(command -v {{ $depends }})" ]; then
{{-       else -}}
else
{{-       end -}}
{{-       "\n" }}
{{-       range get . "aliases" }}{{- "  " -}}
alias {{ get . "name" }}='
{{-         $is_shutdown := get . "note" | eq "shutdown" }}
{{-         if $is_shutdown -}}
{{-           "history -a && exec " }}
{{-         end }}
{{-         range $index, $command := get . "commands"
          | default (get . "command"| list)
          | compact
}}
{{-           if gt $index 0 }}
{{-             " && " }}
{{-           end }}
{{-           printf $command $depends }}
{{-         end -}}
'
{{-         "\n" }}
{{-       end }}
{{-     end -}}
fi
{{-     "\n" }}
{{-   end }}
{{- end -}}
