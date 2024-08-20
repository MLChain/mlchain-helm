{{- define "mlchain.api.credentials" -}}
# A secret key that is used for securely signing the session cookie and encrypting sensitive information on the database. You can generate a strong key using `openssl rand -base64 42`.
SECRET_KEY: {{ .Values.api.secretKey | b64enc | quote }}
{{- if .Values.sandbox.enabled }}
CODE_EXECUTION_API_KEY: {{ .Values.sandbox.auth.apiKey | b64enc | quote }}
{{- end }}
{{- include "mlchain.db.credentials" . }}
# The configurations of redis connection.
# It is consistent with the configuration in the 'redis' service below.
{{- include "mlchain.redis.credentials" . }}
# The configurations of celery broker.
{{- include "mlchain.celery.credentials" . }}
{{ include "mlchain.storage.credentials" . }}
{{ include "mlchain.vectordb.credentials" . }}
{{ include "mlchain.mail.credentials" . }}
{{- end }}

{{- define "mlchain.worker.credentials" -}}
SECRET_KEY: {{ .Values.api.secretKey | b64enc | quote }}
# The configurations of postgres database connection.
# It is consistent with the configuration in the 'db' service below.
{{ include "mlchain.db.credentials" . }}

# The configurations of redis cache connection.
{{ include "mlchain.redis.credentials" . }}
# The configurations of celery broker.
{{ include "mlchain.celery.credentials" . }}

{{ include "mlchain.storage.credentials" . }}
# The Vector store configurations.
{{ include "mlchain.vectordb.credentials" . }}
{{ include "mlchain.mail.credentials" . }}
{{- end }}

{{- define "mlchain.web.credentials" -}}
{{- end }}

{{- define "mlchain.db.credentials" -}}
{{- if .Values.externalPostgres.enabled }}
DB_USERNAME: {{ .Values.externalPostgres.username | b64enc | quote }}
DB_PASSWORD: {{ .Values.externalPostgres.password | b64enc | quote }}
{{- else if .Values.postgresql.enabled }}
  {{ with .Values.postgresql.global.postgresql.auth}}
  {{- if empty .username }}
DB_USERNAME: {{ print "postgres" | b64enc | quote }}
DB_PASSWORD: {{ .postgresPassword | b64enc | quote }}
  {{- else }}
DB_USERNAME: {{ .username | b64enc | quote }}
DB_PASSWORD: {{ .password | b64enc | quote }}
  {{- end }}
  {{- end }}
{{- end }}
{{- end }}

{{- define "mlchain.storage.credentials" -}}
{{- if .Values.externalS3.enabled}}
S3_ACCESS_KEY: {{ .Values.externalS3.accessKey | b64enc | quote }}
S3_SECRET_KEY: {{ .Values.externalS3.secretKey | b64enc | quote }}
{{- else if .Values.externalAzureBlobStorage.enabled }}
# The Azure Blob storage configurations, only available when STORAGE_TYPE is `azure-blob`.
AZURE_BLOB_ACCOUNT_KEY: {{ .Values.externalAzureBlobStorage.key | b64enc | quote }}
{{- else if .Values.externalOSS.enabled }}
ALIYUN_OSS_ACCESS_KEY: {{ .Values.externalOSS.accessKey | b64enc | quote  }}
ALIYUN_OSS_SECRET_KEY: {{ .Values.externalOSS.secretKey | b64enc | quote  }}
{{- else }}
{{- end }}
{{- end }}

{{- define "mlchain.redis.credentials" -}}
{{- if .Values.externalRedis.enabled }}
  {{- with .Values.externalRedis }}
REDIS_USERNAME: {{ .username | b64enc | quote }}
REDIS_PASSWORD: {{ .password | b64enc | quote }}
  {{- end }}
{{- else if .Values.redis.enabled }}
{{- $redisHost := printf "%s-redis-master" .Release.Name -}}
  {{- with .Values.redis }}
REDIS_USERNAME: {{ print "" | b64enc | quote }}
REDIS_PASSWORD: {{ .auth.password | b64enc | quote }}
  {{- end }}
{{- end }}
{{- end }}

{{- define "mlchain.celery.credentials" -}}
# Use redis as the broker, and redis db 1 for celery broker.
{{- if .Values.externalRedis.enabled }}
  {{- with .Values.externalRedis }}
CELERY_BROKER_URL: {{ printf "redis://%s:%s@%s:%v/1" .username .password .host .port | b64enc | quote }}
  {{- end }}
{{- else if .Values.redis.enabled }}
{{- $redisHost := printf "%s-redis-master" .Release.Name -}}
  {{- with .Values.redis }}
CELERY_BROKER_URL: {{ printf "redis://:%s@%s:%v/1" .auth.password $redisHost .master.service.ports.redis | b64enc | quote }}
  {{- end }}
{{- end }}
{{- end }}

{{- define "mlchain.vectordb.credentials" -}}
{{- if .Values.externalWeaviate.enabled }}
WEAVIATE_API_KEY: {{ .Values.externalWeaviate.apiKey | b64enc | quote }}
{{- else if .Values.externalQdrant.enabled }}
QDRANT_API_KEY: {{ .Values.externalQdrant.apiKey | b64enc | quote }}
{{- else if .Values.externalMilvus.enabled}}
MILVUS_USER: {{ .Values.externalMilvus.user | b64enc | quote }}
# The milvus password.
MILVUS_PASSWORD: {{ .Values.externalMilvus.password | b64enc | quote }}
{{- else if .Values.externalPgvector.enabled}}
PGVECTOR_USER: {{ .Values.externalPgvector.username | b64enc | quote }}
# The pgvector password.
PGVECTOR_PASSWORD: {{ .Values.externalPgvector.password | b64enc | quote }}
{{- else if .Values.weaviate.enabled }}
# The Weaviate API key.
  {{- if .Values.weaviate.authentication.apikey }}
WEAVIATE_API_KEY: {{ first .Values.weaviate.authentication.apikey.allowed_keys | b64enc | quote }}
  {{- end }}
{{- end }}
{{- end }}

{{- define "mlchain.mail.credentials" -}}
{{- if eq .Values.api.mail.type "resend" }}
RESEND_API_KEY: {{ .Values.api.mail.resend.apiKey | b64enc | quote }}
{{- else if eq .Values.api.mail.type "smtp" }}
# Mail configuration for SMTP
SMTP_USERNAME: {{ .Values.api.mail.smtp.username | b64enc | quote }}
SMTP_PASSWORD: {{ .Values.api.mail.smtp.password | b64enc | quote }}
{{- end }}
{{- end }}

{{- define "mlchain.sandbox.credentials" -}}
API_KEY: {{ .Values.sandbox.auth.apiKey | b64enc | quote }}
{{- end }}