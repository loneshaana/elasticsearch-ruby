# Licensed to Elasticsearch B.V. under one or more contributor
# license agreements. See the NOTICE file distributed with
# this work for additional information regarding copyright
# ownership. Elasticsearch B.V. licenses this file to you under
# the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.

require "#{File.expand_path(File.dirname('..'), '..')}/api-spec-testing/test_file"
require "#{File.expand_path(File.dirname('..'), '..')}/api-spec-testing/rspec_matchers"
include Elasticsearch::RestAPIYAMLTests

PROJECT_PATH = File.join(File.dirname(__FILE__), '..', '..')

TRANSPORT_OPTIONS = {}
TEST_SUITE = ENV['TEST_SUITE'].freeze

if hosts = ENV['TEST_ES_SERVER'] || ENV['ELASTICSEARCH_HOSTS']
  split_hosts = hosts.split(',').map do |host|
    /(http\:\/\/)?\S+/.match(host)
  end
  uri = URI.parse(split_hosts.first[0])
  TEST_HOST = uri.host
  TEST_PORT = uri.port
else
  TEST_HOST, TEST_PORT = 'localhost', '9200'
end

raw_certificate = File.read(File.join(PROJECT_PATH, '/.ci/certs/testnode.crt'))
certificate = OpenSSL::X509::Certificate.new(raw_certificate)

raw_key = File.read(File.join(PROJECT_PATH, '/.ci/certs/testnode.key'))
key = OpenSSL::PKey::RSA.new(raw_key)

ca_file = File.join(PROJECT_PATH, '/.ci/certs/ca.crt')

if defined?(TEST_HOST) && defined?(TEST_PORT)
  if TEST_SUITE == 'platinum'
    TRANSPORT_OPTIONS.merge!(:ssl => { verify: false,
                                       client_cert: certificate,
                                       client_key: key,
                                       ca_file: ca_file })

    password = ENV['ELASTIC_PASSWORD']
    URL = "https://elastic:#{password}@#{TEST_HOST}:#{TEST_PORT}"
  else
    URL = "http://#{TEST_HOST}:#{TEST_PORT}"
  end

  ADMIN_CLIENT = Elasticsearch::Client.new(host: URL, transport_options: TRANSPORT_OPTIONS)

  if ENV['QUIET'] == 'true'
    DEFAULT_CLIENT = Elasticsearch::Client.new(host: URL, transport_options: TRANSPORT_OPTIONS)
  else
    DEFAULT_CLIENT = Elasticsearch::Client.new(host: URL,
                                               transport_options: TRANSPORT_OPTIONS,
                                               tracer: Logger.new($stdout))
  end
end

YAML_FILES_DIRECTORY = "#{File.expand_path(File.dirname('..'), '..')}" +
    "/tmp/elasticsearch/x-pack/plugin/src/test/resources/rest-api-spec/test"

SINGLE_TEST = if ENV['SINGLE_TEST'] && !ENV['SINGLE_TEST'].empty?
                test_target = ENV['SINGLE_TEST']
                path = File.expand_path(File.dirname('..'), '..')

                if test_target.match?(/\.yml$/)
                  ["#{path}/tmp/elasticsearch/x-pack/plugin/src/test/resources/rest-api-spec/test/#{test_target}"]
                else
                  Dir.glob(
                    ["#{path}/tmp/elasticsearch/x-pack/plugin/src/test/resources/rest-api-spec/test/#{test_target}/*.yml"]
                  )
                end
              end

SKIPPED_TESTS = []

# Respone from Elasticsearch includes the ca.crt, so length doesn't match.
SKIPPED_TESTS << { file:        'ssl/10_basic.yml',
                   description: 'Test get SSL certificates' }

# ArgumentError for empty body
SKIPPED_TESTS << { file:        'watcher/put_watch/10_basic.yml',
                   description: 'Test empty body is rejected by put watch' }

# The number of shards when a snapshot is successfully created is more than 1. Maybe because of the security index?
SKIPPED_TESTS << { file:        'snapshot/10_basic.yml',
                   description: 'Create a source only snapshot and then restore it' }

# The test inserts an invalid license, which makes all subsequent tests fail.
SKIPPED_TESTS << { file:        'xpack/15_basic.yml',
                   description: '*' }

# 'invalidated_tokens' is returning 5 in 'Test invalidate user's tokens' test.
SKIPPED_TESTS << { file:        'token/10_basic.yml',
                   description: "Test invalidate user's tokens" }

SKIPPED_TESTS << { file:        'token/10_basic.yml',
                   description: "Test invalidate realm's tokens" }

# Possible Docker issue. The IP from the response cannot be used to connect.HTTP input supports extracting of keys
SKIPPED_TESTS << { file:        'watcher/execute_watch/60_http_input.yml',
                   description: 'HTTP input supports extracting of keys' }

# Searching the monitoring index returns no results.
SKIPPED_TESTS << { file:        'monitoring/bulk/10_basic.yml',
                   description: 'Bulk indexing of monitoring data on closed indices should throw an export exception' }

# Searching the monitoring index returns no results.
SKIPPED_TESTS << { file:        'monitoring/bulk/20_privileges.yml',
                   description: 'Monitoring Bulk API' }

# Operation times out "failed_node_exception"
SKIPPED_TESTS << { file:        'ml/set_upgrade_mode.yml',
                   description: 'Setting upgrade_mode to enabled' }

# Operation times out "failed_node_exception"
SKIPPED_TESTS << { file:        'ml/set_upgrade_mode.yml',
                   description: 'Setting upgrade_mode to disabled' }

# Operation times out "failed_node_exception"
SKIPPED_TESTS << { file:        'ml/set_upgrade_mode.yml',
                   description: 'Setting upgrade mode to disabled from enabled' }

# Operation times out "failed_node_exception"
SKIPPED_TESTS << { file:        'ml/set_upgrade_mode.yml',
                   description: 'Attempt to open job when upgrade_mode is enabled' }

# 'calendar3' in the field instead of 'calendar2'
SKIPPED_TESTS << { file:        'ml/calendar_crud.yml',
                   description: 'Test PageParams' }

# Error about creating a job that already exists.
SKIPPED_TESTS << { file:        'ml/jobs_crud.yml',
                   description: 'Test close job with body params' }

# Feature is currently experimental.
SKIPPED_TESTS << { file:        'ml/evaluate_data_frame.yml',
                   description: '*' }

# Feature is currently experimental.
SKIPPED_TESTS << { file:        'ml/start_data_frame_analytics.yml',
                   description: '*' }

# Feature is currently experimental.
SKIPPED_TESTS << { file:        'ml/stop_data_frame_analytics.yml',
                   description: '*' }

# Feature is currently experimental.
SKIPPED_TESTS << { file:        'ml/data_frame_analytics_crud.yml',
                   description: '*' }

# https://github.com/elastic/clients-team/issues/142
SKIPPED_TESTS << { file: 'ml/forecast.yml',
                   description: 'Test forecast unknown job' }
SKIPPED_TESTS << { file: 'ml/post_data.yml',
                   description: 'Test POST data with invalid parameters' }
SKIPPED_TESTS << { file: 'ml/post_data.yml',
                   description: 'Test Flush data with invalid parameters' }

# TODO: To be fixed with a release patch
SKIPPED_TESTS << { file: 'api_key/10_basic.yml',
                   description: 'Test get api key' }

# TODO: Failing due to processing of regexp in test
SKIPPED_TESTS << { file: 'ml/explain_data_frame_analytics.yml',
                   description: 'Test non-empty data frame given body'}

# Transform tests have issues with text fields/keywords in setup
SKIPPED_TESTS << { file: 'transform/transforms_stats.yml',
                   description: '*' }
SKIPPED_TESTS << { file: 'transform/transforms_update.yml',
                   description: '*' }
SKIPPED_TESTS << { file: 'transform/transforms_cat_apis.yml',
                   description: '*' }
SKIPPED_TESTS << { file: 'transform/transforms_crud.yml',
                   description: '*' }
SKIPPED_TESTS << { file: 'transform/transforms_stats_continuous.yml',
                   description: '*' }
SKIPPED_TESTS << { file: 'transform/transforms_force_delete.yml',
                   description: '*' }
SKIPPED_TESTS << { file: 'transform/transforms_start_stop.yml',
                   description: '*' }

# TODO https://github.com/elastic/elasticsearch-ruby/issues/852
SKIPPED_TESTS << { file: 'analytics/usage.yml',
                   description: 'Usage stats on analytics indices' }

# TODO https://github.com/elastic/elasticsearch-ruby/issues/853
SKIPPED_TESTS << { file: 'ml/jobs_crud.yml',
                   description: 'Test put job with model_memory_limit as string and lazy open' }

# The directory of rest api YAML files.
REST_API_YAML_FILES = SINGLE_TEST || Dir.glob("#{YAML_FILES_DIRECTORY}/**/*.yml")

# The features to skip
REST_API_YAML_SKIP_FEATURES = ['warnings', 'node_selector'].freeze
