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
    module Actions
      # Get multiple term vectors.
      # Get multiple term vectors with a single request.
      # You can specify existing documents by index and ID or provide artificial documents in the body of the request.
      # You can specify the index in the request body or request URI.
      # The response contains a `docs` array with all the fetched termvectors.
      # Each element has the structure provided by the termvectors API.
      # **Artificial documents**
      # You can also use `mtermvectors` to generate term vectors for artificial documents provided in the body of the request.
      # The mapping used is determined by the specified `_index`.
      #
      # @option arguments [String] :index The name of the index that contains the documents.
      # @option arguments [Array<String>] :ids A comma-separated list of documents ids. You must define ids as parameter or set "ids" or "docs" in the request body
      # @option arguments [String, Array<String>] :fields A comma-separated list or wildcard expressions of fields to include in the statistics.
      #  It is used as the default list unless a specific field list is provided in the `completion_fields` or `fielddata_fields` parameters.
      # @option arguments [Boolean] :field_statistics If `true`, the response includes the document count, sum of document frequencies, and sum of total term frequencies. Server default: true.
      # @option arguments [Boolean] :offsets If `true`, the response includes term offsets. Server default: true.
      # @option arguments [Boolean] :payloads If `true`, the response includes term payloads. Server default: true.
      # @option arguments [Boolean] :positions If `true`, the response includes term positions. Server default: true.
      # @option arguments [String] :preference The node or shard the operation should be performed on.
      #  It is random by default.
      # @option arguments [Boolean] :realtime If true, the request is real-time as opposed to near-real-time. Server default: true.
      # @option arguments [String] :routing A custom value used to route operations to a specific shard.
      # @option arguments [Boolean] :term_statistics If true, the response includes term frequency and document frequency.
      # @option arguments [Integer] :version If `true`, returns the document version as part of a hit.
      # @option arguments [String] :version_type The version type.
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
      # @option arguments [Hash] :body request body
      #
      # @see https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-mtermvectors
      #
      def mtermvectors(arguments = {})
        request_opts = { endpoint: arguments[:endpoint] || 'mtermvectors' }

        defined_params = [:index].each_with_object({}) do |variable, set_variables|
          set_variables[variable] = arguments[variable] if arguments.key?(variable)
        end
        request_opts[:defined_params] = defined_params unless defined_params.empty?

        arguments = arguments.clone
        headers = arguments.delete(:headers) || {}

        body = arguments.delete(:body)

        _index = arguments.delete(:index)

        method = if body
                   Elasticsearch::API::HTTP_POST
                 else
                   Elasticsearch::API::HTTP_GET
                 end

        path   = if _index
                   "#{Utils.listify(_index)}/_mtermvectors"
                 else
                   '_mtermvectors'
                 end
        params = Utils.process_params(arguments)

        Elasticsearch::API::Response.new(
          perform_request(method, path, params, body, headers, request_opts)
        )
      end
    end
  end
end
