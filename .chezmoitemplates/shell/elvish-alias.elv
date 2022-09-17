{{- $alias_list := includeTemplate "shell/alias-list" . | fromJson }}
{{-   range $alias_list }}
{{-     $depends_list := get . "depends_list"
        | default (hasKey . "depends"
          | ternary . ""
          | list)
        | compact
}}
{{-     if empty $depends_list -}}
edit:add-var {{ get . "name"}} {{ template "shell/elvish-alias-body.elv" . }}
{{-       "\n" }}
{{-     else }}
{{-       "\n" }}
{{-       range $index, $depends_info := $depends_list }}
{{-         $depends := get $depends_info "depends" }}
{{-         if $depends }}
{{-           if $index | eq 0 -}}
if
{{-           else -}}
} elif
{{-           end }}{{- " " -}}
  (has-external {{ $depends }}) {
{{-         else -}}
} else {
{{-         end -}}
{{-         "\n" }}{{- "  " -}}
  edit:add-vars [
{{-         "\n" }}
{{-         range get . "aliases" }}{{- "    " -}}
    &{{get . "name"}}~=
{{-           template "shell/elvish-alias-body.elv" (merge . (dict "depends" $depends)) }}
{{-           "\n" }}
{{-         end }}{{- "  " -}}
  ]
{{-         "\n" }}
{{-       end -}}
}
{{-       "\n" }}
{{-     end }}
{{-   end }}
