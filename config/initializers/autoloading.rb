module Integrations; end

Rails.autoloaders.main.push_dir("#{Rails.root}/app/integrations", namespace: Integrations)
