class Link < ActiveRecord::Base

  ALLOWED_CHARS = ([*('a'..'z'),*('0'..'9'),*('A'..'Z'), ['_']])

  validates :shortcode, format: { with: /\A[0-9a-zA-Z_]{4,}\Z/, message: "422"}
  validates :shortcode, uniqueness: {message: "409"}
  validates :shortcode, presence: { message: "400" }
  validates :shortcode, length: {in: 4..255, message: "422" }

  validates :url, presence: { message: "400" }
  validates :url, format: { with: URI.regexp, message: "422"}

  before_validation :generate_shortcode

  def generate_shortcode
    self.shortcode ||= loop do
      temp_shortcode = (0..6).map{ Link::ALLOWED_CHARS.sample }.join
      break temp_shortcode unless Link.exists?(shortcode: temp_shortcode) # maybe break after x counts
    end
  end

  def track_redirect!
    increment!(:redirect_count)
  end
end
