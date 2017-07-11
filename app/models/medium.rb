# Medium class
class Medium < ApplicationRecord
  has_many :asset_media
  has_many :learning_assets, through: :asset_media
  validates :author, presence: true
  validates :title, presence: true
  validate :nonempty_content?
  validates :width, presence: true,
                    numericality: { only_integer: true,
                                    greater_than_or_equal_to: 100,
                                    less_than_or_equal_to: 8192 },
                    if: :video_content?
  validates :height, presence: true,
                     numericality: { only_integer: true,
                                     greater_than_or_equal_to: 100,
                                     less_than_or_equal_to: 4320 },
                     if: :video_content?
  validates :embedded_width, presence: true,
                             numericality: { only_integer: true,
                                             greater_than_or_equal_to: 100,
                                             less_than_or_equal_to: 8192 },
                             if: :video_content?
  validates :embedded_height, presence: true,
                              numericality: { only_integer: true,
                                              greater_than_or_equal_to: 100,
                                              less_than_or_equal_to: 4320 },
                              if: :video_content?

  validates :length, presence: true,
                     numericality: { only_integer: true,
                                     greater_than_or_equal_to: 1,
                                     less_than_or_equal_to: 36_000 },
                     if: :video_content?
  validates :video_size, presence: true,
                         format:
                           { with: /\A([\d,.]+)?\s?(?:([kmgtpezy])i)?b\z/i },
                         if: :video_file_content?
  validates :pages, presence: true,
                    numericality: { only_integer: true,
                                    greater_than_or_equal_to: 1,
                                    less_than_or_equal_to: 2000 },
                    if: :manuscript_content?
  validates :manuscript_size, presence: true,
                              format:
                                { with: /\A([\d,.]+)?\s?(?:([kmgtpezy])i)?b\z/i },
                              if: :manuscript_content?


  def nonempty_content?
    return true if video_stream_link.present? ||
                   video_file_link.present? ||
                   manuscript_link.present? ||
                   external_reference_link.present?
    errors.add(:base, 'empty content')
    false
  end

  def video_content?
    video_stream_link.present? || video_file_link.present?
  end

  def video_stream_content?
    video_stream_link.present?
  end

  def video_file_content?
    video_file_link.present?
  end

  def manuscript_content?
    manuscript_link.present?
  end
end
