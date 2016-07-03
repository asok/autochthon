begin
  require 'active_record'

  module Autochthon
    module ActiveRecord
      class Migration < ::ActiveRecord::Migration
        def change
          create_table :translations do |t|
            t.string :locale
            t.string :key
            t.text   :value
            t.text   :interpolations
            t.boolean :is_proc, default: false

            t.timestamps null: false
          end
        end
      end
    end
  end
rescue LoadError
end
