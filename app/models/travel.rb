class Travel < ApplicationRecord

  #tweetsテーブルから中間テーブルに対する関連付け
  has_many :travel_tag_relations, dependent: :destroy
  #tweetsテーブルから中間テーブルを介してTagsテーブルへの関連付け
  has_many :tags, through: :travel_tag_relations, dependent: :destroy

    belongs_to :user


    has_one_attached :image 

end
