module Enums
  class Status
    attr_reader :name

    def initialize(name)
      @name = name
    end

    REQUESTED   = new(:Requested)
    PENDING     = new(:Pending)
    STARTED     = new(:Started)
    PREPARING   = new(:Preparing)
    BUILDING    = new(:Building)
    SIGNING     = new(:Signing)
    PUBLISHING  = new(:Publishing)
    COMPLETED   = new(:Completed)
    FAILED      = new(:Failed)
    CANCELLED   = new(:Cancelled)

    ALL = [
      REQUESTED,
      PENDING,
      PREPARING,
      BUILDING,
      SIGNING,
      PUBLISHING,
      COMPLETED,
      FAILED,
      CANCELLED
    ]

    def to_s
      @name.to_s
    end
  end
end
