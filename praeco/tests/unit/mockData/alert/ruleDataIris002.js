export const ruleYaml = `__praeco_query_builder: '{"query":{"logicalOperator":"all","children":[]}}'
alert:
  - iris
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
import: BaseRule.config
index: hannibal-*
iris_alert_note: a
iris_alert_severity_id: 2
iris_alert_source_link: b
iris_alert_status_id: 3
iris_alert_tags: c
iris_api_token: abcdefghijklmnopqrstuvwxyz
iris_case_template_id: 5
iris_customer_id: 4
iris_description: d
iris_host: testserver
iris_ignore_ssl_errors: true
iris_overwrite_timestamp: true
iris_type: case
is_enabled: false
name: test123
num_events: 10000
query_key: beat.hostname
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
