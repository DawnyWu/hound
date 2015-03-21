class PaymentGatewaySubscription
  attr_reader :subscription

  delegate :id, :metadata, :save, :delete, to: :subscription

  def initialize(subscription, new_subscription: false)
    @subscription = subscription
    @new_subscription = new_subscription
  end

  def subscribe(repo_id)
    append_repo_id_to_metadata(repo_id)
    if existing_subscription?
      increment_quantity
    end
  end

  def unsubscribe(repo_id)
    if subscription.quantity > 1
      remove_repo_id_from_metadata(repo_id)
      decrement_quantity
    else
      delete
    end
  end

  def increment_quantity
    subscription.quantity += 1
    save
  end

  def decrement_quantity
    subscription.quantity -= 1
    save
  end

  def plan
    subscription.plan.id
  end

  def existing_subscription?
    !@new_subscription
  end

  def new_subscription?
    @new_subscription
  end

  private

  def current_repo_ids
    Array(metadata["repo_ids"] || metadata["repo_id"])
  end

  def append_repo_id_to_metadata(repo_id)
    repo_ids = current_repo_ids + [repo_id]

    if metadata["repo_id"]
      metadata["repo_id"] = nil
    end

    metadata["repo_ids"] = repo_ids.map(&:to_s)
  end

  def remove_repo_id_from_metadata(repo_id)
    metadata["repo_ids"] = current_repo_ids.reject do |id|
      id.to_s == repo_id.to_s
    end
  end
end
