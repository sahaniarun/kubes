module Kubes
  class Config
    include Singleton
    include DslEvaluator

    attr_reader :config
    def initialize
      @config = defaults
    end

    def defaults
      config = ActiveSupport::OrderedOptions.new

      config.auto_prune = true

      config.builder = "docker" # IE: docker or gcloud

      # Auto-switching options
      config.kubectl = ActiveSupport::OrderedOptions.new
      config.kubectl.context = nil
      config.kubectl.context_keep = true # after switching context keep it

      # whether or not continue if the kubectl command fails
      config.kubectl.exit_on_fail = ActiveSupport::OrderedOptions.new
      config.kubectl.exit_on_fail.apply  = true # whether or not continue if the kubectl apply command fails
      config.kubectl.exit_on_fail.delete = false # whether or not continue if the kubectl delete command fails
      # Note: delete is a internal method to ActiveSupport::OrderedOptions so will have to access it with ['...']

      config.kubectl.order = ActiveSupport::OrderedOptions.new
      config.kubectl.order.roles = role_order
      config.kubectl.order.kinds = kind_order

      config.repo = nil # expected to be set by .kubes/config.rb

      config.logger = Logger.new($stdout)
      config.logger.level = ENV['KUBES_LOG_LEVEL'] || :info

      config.skip = []

      config.state = ActiveSupport::OrderedOptions.new
      config.state.docker_image_path = "#{Kubes.root}/.kubes/state/docker_image.txt"

      config.suffix_hash = true # append suffix hash to ConfigMap and Secret

      config
    end

    # Create shared resources first
    def role_order
      %w[
        common
        shared
      ]
    end

    # Create resources in specific order so dependent resources are available
    def kind_order
      %w[
        Namespace
        StorageClass
        CustomResourceDefinition
        MutatingWebhookConfiguration
        ServiceAccount
        PodSecurityPolicy
        Role
        ClusterRole
        RoleBinding
        ClusterRoleBinding
        ConfigMap
        Secret
        Service
        LimitRange
        Deployment
        StatefulSet
        CronJob
        PodDisruptionBudget
      ]
    end

    def configure
      yield(@config)
    end

    def load_configs
      evaluate_file(".kubes/config.rb")
      evaluate_file(".kubes/config/env/#{Kubes.env}.rb")
    end
  end
end
