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
#
# This code was automatically generated from the Elasticsearch Specification
# See https://github.com/elastic/elasticsearch-specification
# See Elasticsearch::ES_SPECIFICATION_COMMIT for commit hash.
module Elasticsearch
  module API
    module Indices
      module Actions
        # Get index information.
        # Get information about one or more indices. For data streams, the API returns information about the
        # stream’s backing indices.
        #
        # @option arguments [String, Array] :index Comma-separated list of data streams, indices, and index aliases used to limit the request.
        #  Wildcard expressions (*) are supported. (*Required*)
        # @option arguments [Boolean] :allow_no_indices If false, the request returns an error if any wildcard expression, index alias, or _all value targets only
        #  missing or closed indices. This behavior applies even if the request targets other open indices. For example,
        #  a request targeting foo*,bar* returns an error if an index starts with foo but no index starts with bar. Server default: true.
        # @option arguments [String, Array<String>] :expand_wildcards Type of index that wildcard expressions can match. If the request can target data streams, this argument
        #  determines whether wildcard expressions match hidden data streams. Supports comma-separated values,
        #  such as open,hidden. Server default: open.
        # @option arguments [Boolean] :flat_settings If true, returns settings in flat format.
        # @option arguments [Boolean] :ignore_unavailable If false, requests that target a missing index return an error.
        # @option arguments [Boolean] :include_defaults If true, return all default settings in the response.
        # @option arguments [Boolean] :local If true, the request retrieves information from the local node only. Defaults to false, which means information is retrieved from the master node.
        # @option arguments [Time] :master_timeout Period to wait for a connection to the master node. If no response is received before the timeout expires, the request fails and returns an error. Server default: 30s.
        # @option arguments [String, Array<String>] :features Return only information on specified index features Server default: ['aliases', 'mappings', 'settings'].
        # @option arguments [Boolean] :error_trace When set to `true` Elasticsearch will include the full stack trace of errors
        #  when they occur.
        # @option arguments [String, Array<String>] :filter_path Comma-separated list of filters in dot notation which reduce the response
        #  returned by Elasticsearch.
        # @option arguments [Boolean] :human When set to `true` will return statistics in a format suitable for humans.
        #  For example `"exists_time": "1h"` for humans and
        #  `"exists_time_in_millis": 3600000` for computers. When disabled the human
        #  readable values will be omitted. This makes sense for responses being consumed
        #  only by machines.
        # @option arguments [Boolean] :pretty If set to `true` the returned JSON will be "pretty-formatted". Only use
        #  this option for debugging only.
        # @option arguments [Hash] :headers Custom HTTP headers
        #
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-indices-get
        #
        def get(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'indices.get' }

          defined_params = [:index].each_with_object({}) do |variable, set_variables|
            set_variables[variable] = arguments[variable] if arguments.key?(variable)
          end
          request_opts[:defined_params] = defined_params unless defined_params.empty?

          raise ArgumentError, "Required argument 'index' missing" unless arguments[:index]

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = nil

          _index = arguments.delete(:index)

          method = Elasticsearch::API::HTTP_GET
          path   = Utils.listify(_index).to_s
          params = Utils.process_params(arguments)

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end
