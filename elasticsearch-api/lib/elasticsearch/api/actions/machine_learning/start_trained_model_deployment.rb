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
    module MachineLearning
      module Actions
        # Start a trained model deployment.
        # It allocates the model to every machine learning node.
        #
        # @option arguments [String] :model_id The unique identifier of the trained model. Currently, only PyTorch models are supported. (*Required*)
        # @option arguments [Integer, String] :cache_size The inference cache size (in memory outside the JVM heap) per node for the model.
        #  The default value is the same size as the `model_size_bytes`. To disable the cache,
        #  `0b` can be provided.
        # @option arguments [String] :deployment_id A unique identifier for the deployment of the model.
        # @option arguments [Integer] :number_of_allocations The number of model allocations on each node where the model is deployed.
        #  All allocations on a node share the same copy of the model in memory but use
        #  a separate set of threads to evaluate the model.
        #  Increasing this value generally increases the throughput.
        #  If this setting is greater than the number of hardware threads
        #  it will automatically be changed to a value less than the number of hardware threads.
        #  If adaptive_allocations is enabled, do not set this value, because it’s automatically set. Server default: 1.
        # @option arguments [String] :priority The deployment priority.
        # @option arguments [Integer] :queue_capacity Specifies the number of inference requests that are allowed in the queue. After the number of requests exceeds
        #  this value, new requests are rejected with a 429 error. Server default: 1024.
        # @option arguments [Integer] :threads_per_allocation Sets the number of threads used by each model allocation during inference. This generally increases
        #  the inference speed. The inference process is a compute-bound process; any number
        #  greater than the number of available hardware threads on the machine does not increase the
        #  inference speed. If this setting is greater than the number of hardware threads
        #  it will automatically be changed to a value less than the number of hardware threads. Server default: 1.
        # @option arguments [Time] :timeout Specifies the amount of time to wait for the model to deploy. Server default: 20s.
        # @option arguments [String] :wait_for Specifies the allocation status to wait for before returning. Server default: started.
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
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-ml-start-trained-model-deployment
        #
        def start_trained_model_deployment(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'ml.start_trained_model_deployment' }

          defined_params = [:model_id].each_with_object({}) do |variable, set_variables|
            set_variables[variable] = arguments[variable] if arguments.key?(variable)
          end
          request_opts[:defined_params] = defined_params unless defined_params.empty?

          raise ArgumentError, "Required argument 'model_id' missing" unless arguments[:model_id]

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = arguments.delete(:body)

          _model_id = arguments.delete(:model_id)

          method = Elasticsearch::API::HTTP_POST
          path   = "_ml/trained_models/#{Utils.listify(_model_id)}/deployment/_start"
          params = Utils.process_params(arguments)

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end
