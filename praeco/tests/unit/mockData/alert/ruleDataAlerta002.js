export const ruleYaml = `__praeco_query_builder: '{"query":{"logicalOperator":"all","children":[]}}'
alert:
  - alerta
alert_subject: this is a test subject
alert_subject_args: []
alert_text: this is a test body
alert_text_args: []
alert_text_type: alert_text_only
alerta_api_key: a
alerta_api_skip_ssl: true
alerta_api_url: http://testserver/
alerta_attributes_keys:
  - a
  - b
alerta_attributes_values:
  - c
  - d
alerta_correlate:
  - e
  - f
alerta_service:
  - g
  - h
alerta_timeout: 88000
alerta_use_match_timestamp: true
alerta_use_qk_as_resource: true
doc_type: syslog
filter:
  - query:
      query_string:
        query: '@timestamp:*'
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
