module Enums
  class Status
    attr_reader :name

    def initialize(name)
      @name = name
    end

    REQUESTED   = new(:requested)
    PENDING     = new(:pending)
    STARTED     = new(:started)
    PREPARING   = new(:preparing)
    BUILDING    = new(:building)
    SIGNING     = new(:signing)
    PUBLISHING  = new(:publishing)
    COMPLETED   = new(:completed)
    FAILED      = new(:failed)
    CANCELLED   = new(:cancelled)

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
