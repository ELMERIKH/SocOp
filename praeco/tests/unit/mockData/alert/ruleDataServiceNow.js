export const ruleYaml = `__praeco_query_builder: '{"query":{"logicalOperator":"all","children":[]}}'
alert:
  - servicenow
alert_subject: this is a test subject
alert_subject_args: []
alert_text: this is a test body
alert_text_args: []
alert_text_type: alert_text_only
assignment_group: 'a1'
caller_id: 'a2'
category: 'a3'
cmdb_ci: 'a4'
comments: 'a5'
doc_type: 'syslog'
filter:
  - query:
      query_string:
        query: '@timestamp:*'
generate_kibana_discover_url: false
import: 'BaseRule.config'
index: 'hannibal-*'
is_enabled: false
match_enhancements: []
name: 'test123'
num_events: 10000
password: 'a6'
realert:
  minutes: 5
servicenow_impact: 'a7'
servicenow_proxy: 'hostname:8080'
servicenow_rest_url: 'http://testserver/'
servicenow_urgency: 'a11'
short_description: 'a8'
subcategory: 'a9'
terms_size: 50
timeframe:
  minutes: 5
timestamp_field: '@timestamp'
timestamp_type: 'iso'
type: 'frequency'
use_count_query: true
username: 'a10'
`;
