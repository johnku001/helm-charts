{{- define "service.service_single" -}}
apiVersion: v1
kind: Service
metadata:
  name: {{ .Values.name }}
  annotations: {{ toYaml .Values.service.annotations | nindent 4 }}
  labels: {{ toYaml .Values.service.labels | nindent 4 }}
spec:
{{- if and (hasKey .Values.service "type") (eq .Values.service.type "ExternalName")}}
  type: {{ .Values.service.type}}
  externalName: {{ .Values.service.externalName }}
{{- else}}
  ports:
{{- range .Values.service.ports }}
  - name: {{ .name | default .port | quote }}
    port: {{ .port }}
    targetPort: {{ .target | default .port }}
    protocol: {{ .protocol | default "TCP" }}
{{- end}}
  type: {{ .Values.service.type | default "ClusterIP" }}
  selector:
    app: {{ .Values.name }}
{{- end }}
{{- end }}