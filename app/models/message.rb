class Message < ApplicationRecord
  include HasUuid

  enum :author, {
    advertiser: 0,
    lead: 1,
  }

  belongs_to :message_thread, touch: true

  after_commit :send_to_peer, on: :create

  delegate :peer, :ad, to: :message_thread

  def ordinalized_peer_name
    "#{ad.hops.ordinalize}˚ peer via #{ad.peer_name}"
  end

  def upsert_from_peer!(*args)
    raise 'to be implemented in subclass'
  end
end
