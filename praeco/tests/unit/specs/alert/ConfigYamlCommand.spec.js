import { expect } from 'chai';
import store from '@/store';
import { mockAxios } from '../../setup';
import { ruleYaml } from '../../mockData/alert/ruleDataCommand.js';

describe('Command YAML parsing', () => {
  it('renders the correct yaml', async () => {
    mockAxios.onGet('/api/rules/test123').reply(200, { yaml: ruleYaml });
    await store.dispatch('config/load', { type: 'rules', path: 'test123' });
    let yaml = store.getters['config/yaml']();

    let expected = `__praeco_full_path: "test123"
__praeco_query_builder: "{\\"query\\":{\\"logicalOperator\\":\\"all\\",\\"children\\":[]}}"
alert:
  - "command"
command:
  - "a"
  - "b"
  - "c"
doc_type: "syslog"
fail_on_non_zero_exit: true
filter:
  - query:
      query_string:
        query: "@timestamp:*"
import: "BaseRule.config"
index: "hannibal-*"
is_enabled: false
match_enhancements: []
name: "test123"
num_events: 10000
pipe_alert_text: true
pipe_match_json: true
realert:
  minutes: 5
terms_size: 50
timeframe:
  minutes: 5
timestamp_field: "@timestamp"
timestamp_type: "iso"
type: "frequency"
use_count_query: true
use_strftime_index: false
`;

    return expect(yaml).to.equal(expected);
  });
});
