{{/*
Expand the name of the chart.
*/}}
{{- define "order-manager.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Setup the environment of the chart.
*/}}
{{- define "order-manager.env" -}}
{{- if ( .Release.Namespace | toString | regexFind "test") -}}
{{- default "test" -}}
{{- else if ( .Release.Namespace | toString | regexFind "dev") -}}
{{- default "dev" -}}
{{- else if ( .Release.Namespace | toString | regexFind "qa") -}}
{{- default "qa" -}}
{{- else if ( .Release.Namespace | toString | regexFind "stage") -}}
{{- default "stage" -}}
{{- else if ( .Release.Namespace | toString | regexFind "prod") -}}
{{- default "prod" -}}
{{- else if ( .Release.Namespace | toString | regexFind "demo") -}}
{{- default "demo" -}}
{{- else if ( .Release.Namespace | toString | regexFind "dr") -}}
{{- default "dr" -}}
{{- else -}}
{{- default "test" -}}
{{- end -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "order-manager.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "order-manager.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "order-manager.labels" -}}
helm.sh/chart: {{ include "order-manager.chart" . }}
{{ include "order-manager.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "order-manager.selectorLabels" -}}
name: {{ include "order-manager.name" . }}
instance: {{ .Release.Name }}
env: {{ include "order-manager.env" . }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "order-manager.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "order-manager.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}
