export const ruleYaml = `__praeco_query_builder: '{"query":{"logicalOperator":"all","children":[]}}'
alert:
  - post
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
http_post_url: http://localhost/webhook
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
