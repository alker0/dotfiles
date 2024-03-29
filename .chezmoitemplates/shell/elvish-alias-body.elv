{{- $depends := get . "depends" }}
{{- $is_shutdown := get . "note" | eq "shutdown" }}

{{- "[@arg]{ " }}

{{- if $is_shutdown -}}
{{-   "exec " }}
{{- end }}

{{- range $index, $command := get . "commands"
    | default (get . "command" | list)
    | compact
}}
{{-   if gt $index 0 }}
{{-     " ; " }}
{{-   end }}

{{-   if $depends }}
{{-     printf $command $depends }}
{{-   else }}
{{-     printf $command }}
{{-   end }}

{{- end }}

{{- " $@arg }" -}}
