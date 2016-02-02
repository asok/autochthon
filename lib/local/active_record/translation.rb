module Local
  module ActiveRecord
    class Translation < I18n::Backend::ActiveRecord::Translation
      def self.[](id)
        where(id: id).last
      end

      def self.insert(params)
        create!(params)
      end
    end if defined?(I18n::Backend::ActiveRecord::Translation)
  end
end
