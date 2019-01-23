class User < ApplicationRecord
  has_many :active_relationships, class_name: Relationship.name,
    foreign_key: :follower_id, dependent: :destroy
  has_many :passive_relationships, class_name: Relationship.name,
    foreign_key: :followed_id, dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower
  has_many :suggests
  has_and_belongs_to_many :subtitles
  has_many :favorited_movies, foreign_key: :user_id, class_name: Favorite.name,
    dependent: :destroy
  has_many :favoriting, through: :favorited_movies, source: :movie
  has_many :movie_followings, foreign_key: :user_id,
    class_name: MovieFollowing.name, dependent: :destroy
  has_many :followed_movies, through: :movie_followings, source: :movie
  has_many :rating_movies, dependent: :destroy, foreign_key: :user_id
  has_many :rated_movies, through: :rating_movies, source: :movie
  has_many :comments, dependent: :destroy
  has_many :user_movies, dependent: :destroy, foreign_key: :user_id
  has_many :watched_movies, through: :user_movies, source: :movie
  has_many :movie_vocabularies, foreign_key: :user_id,
    class_name: UserVocabulary.name, dependent: :destroy
  has_many :vocabularies, through: :movie_vocabularies, source: :movie

  enum gender: %i(male female)
  enum role: %i(member admin)

  has_secure_password

  def self.digest string
    cost = if ActiveModel::SecurePassword.min_cost
             BCrypt::Engine::MIN_COST
           else
             BCrypt::Engine.cost
           end
    BCrypt::Password.create string, cost: cost
  end

  # Follows a user.
  def follow other_user
    following << other_user
  end

  # Unfollows a user.
  def unfollow other_user
    following.delete other_user
  end
end
