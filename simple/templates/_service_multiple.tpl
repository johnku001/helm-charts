{{- define "service.service_multiple" -}}
  {{- range $service_name, $ref := .Values.services }}
---
apiVersion: v1
kind: Service
metadata:
  name: {{ $service_name }}
  annotations: {{ toYaml $ref.annotations | nindent 4 }}
  labels: {{ toYaml $ref.labels | nindent 4 }}
spec:
    {{- if and (hasKey $ref "type") (eq $ref.type "ExternalName")}}
  type: {{ $ref.type}}
  externalName: {{ $ref.externalName }}
    {{- else}}
  ports:
      {{- range $ref.ports }}
  - name: {{ .name | default .port | quote }}
    port: {{ .port }}
    targetPort: {{ .target | default .port }}
    protocol: {{ .protocol | default "TCP" }}
      {{- end}}
  type: {{ $ref.type | default "ClusterIP" }}
    {{- if hasKey $ref "clusterIP" }}
  clusterIP: {{ $ref.clusterIP  }}
    {{- end }}  
  selector:
    app: {{ $ref.selector.app | default $service_name }}
    {{- end }}
  {{- end }}
{{- end -}}