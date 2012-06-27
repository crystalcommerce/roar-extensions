module RoarExtensions
  module DestroyedRecordPresenter
    def self.included(receiver)
      receiver.send(:include, RoarExtensions::Presenter)

      receiver.instance_eval do
        property :id

        alias_method :id, :record
      end
    end

  end
end
