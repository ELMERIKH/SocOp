export const ruleYaml = `__praeco_query_builder: '{"query":{"logicalOperator":"all","children":[]}}'
alert:
  - gelf
alert_subject: this is a test subject
alert_subject_args: []
alert_text: this is a test body
alert_text_args: []
alert_text_type: alert_text_only
doc_type: syslog
filter:
  - query:
      query_string:
        query: '@timestamp:*'
gelf_ca_cert: /etc/ssl/elasticsearch/cert
gelf_endpoint: http://example.com
gelf_http_ignore_ssl_errors: true
gelf_log_level: 0
gelf_timeout: 10
gelf_type: http
import: BaseRule.config
index: hannibal-*
is_enabled: false
name: test123
num_events: 10000
realert:
  minutes: 5
timeframe:
  minutes: 5
timestamp_field: '@timestamp'
timestamp_type: iso
type: frequency
use_count_query: true
use_strftime_index: false
`;
