{{- $alias_list := includeTemplate "shell/alias-list" . | fromJson }}
{{- range $alias_list }}
{{-   $depends_list := get . "depends_list"
    | default (list (hasKey . "depends" | ternary . ""))
    | compact
}}
{{-   if empty $depends_list -}}
alias {{ get . "name" }}='{{ get . "command" }}'
{{    else }}
{{-     $alias_indent := "" }}
{{-     $missing_depends := true }}
{{-     $check_on_run := get . "check_on_run" }}
{{-     if not $check_on_run }}
{{-       range $depends_info := $depends_list }}
{{-         if $missing_depends }}
{{-           $depends := get $depends_info "depends" }}
{{-           if lookPath $depends }}
{{-             $depends_list = list $depends_info }}
{{-             $missing_depends = false }}
{{-           end }}
{{-         end }}
{{-       end }}
{{-       if $missing_depends }}
{{-         $depends_list = list }}
{{-       end }}
{{-     end }}
{{-     "\n" }}
{{-     range $index, $depends_info := $depends_list }}
{{-       $depends := get $depends_info "depends" }}
{{-       if $check_on_run }}
{{-         if $depends }}
{{-           if $index | eq 0 -}}
if
{{-             $alias_indent = "  " }}
{{-             $missing_depends = false }}
{{-           else }}
elif
{{-           end }}{{- " " -}}
  [ -n "$(command -v {{ $depends }})" ]; then{{ "\n" }}
{{-         else if gt $index 0 }}
else{{ "\n" }}
{{-         end }}
{{-       end }}
{{-       if not $missing_depends -}}
{{-         range get . "aliases" }}
{{-           $alias := . }}{{- $alias_indent -}}
alias {{ get $alias "name" }}='
{{-           $is_shutdown := get $alias "note" | eq "shutdown" }}
{{-           if $is_shutdown -}}
{{-             "history -a && exec " }}
{{-           end }}
{{-           range $index, $command := get $alias "commands"
            | default (get $alias "command"| list)
            | compact
}}
{{-             if gt $index 0 }}
{{-               " && " }}
{{-             end }}
{{-             if hasKey $alias "env" }}
{{-               $env_dic := get $alias "env" }}
{{-               range $env_name := keys $env_dic }}
{{-                 printf "%s=" $env_name }}
{{-                 $env_value := get $env_dic $env_name }}
{{-                 if $env_value | contains "'" }}
{{-                   $env_value = $env_value | replace "'" "'\"'\"'" }}
{{-                 end }}
{{-                 if $env_value | contains " " }}
{{-                   printf "%s " ($env_value | squote | quote | squote) }}
{{-                 else }}
{{-                   printf "%s " $env_value }}
{{-                 end }}
{{-               end }}
{{-             end }}
{{-             printf $command $depends }}
{{-           end -}}
'{{ "\n" }}
{{-         end }}
{{-       end }}
{{-     end }}
{{-     if $check_on_run -}}
fi{{ "\n" }}
{{-     end }}
{{-   end }}
{{- end -}}
