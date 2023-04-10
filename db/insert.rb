require 'csv'
require 'active_record'
require "active_support/all"

# Timezoneの設定
Time.zone_default = Time.find_zone! 'Tokyo'
ActiveRecord::Base.default_timezone = :local
# ロガーの設定
ActiveRecord::Base.logger = Logger.new(STDOUT)
# DB情報
ActiveRecord::Base.establish_connection(
  "adapter" => "sqlite3",
  "database" => "./development.sqlite3"
  # if Rails.env.production?
  #   "adapter" => "postgresql",
  #   "database" => "./development.postgresql"
  # else
  #   "adapter" => "sqlite3",
  #   "database" => "./development.sqlite3"
  # end
  # → postgresqlとsqlite3の仕様が異なるため、うまくできない
)
# Modelを定義
class ExternalSite < ActiveRecord::Base
  self.table_name = 'external_sites'
end

class Tag < ActiveRecord::Base
  self.table_name = 'tags'
end

# class TagMap < ActiveRecord::Base
#   self.table_name = 'tag_maps'
# end

class ExtagMap < ActiveRecord::Base
  self.table_name = 'extag_maps'
end

#タグがなかったら、そのタグを作成する
def create_tag(tag_name)
  start_time = Time.now
  ActiveRecord::Base.transaction do
    Tag.create(tag_name: tag_name)
  end
  "transaction: #{Time.now - start_time}s"
end

def getTagId(tagNames)
  insert_tagIds = []
  tagNames.each do |tag_name|
    tag_name.strip!
    column = Tag.find_by(tag_name: tag_name)
    if column == nil
      create_tag(tag_name)
      column = Tag.find_by(tag_name: tag_name)
      tag_id = column.id
      insert_tagIds.push(tag_id)
    else
      tag_id = column.id
      insert_tagIds.push(tag_id)
    end
  end
  insert_tagIds
end

def csv_to_records(filename)
  insert_records = []
  all_tagIds = []
  CSV.foreach(filename) do |row|
    tagNames = row[4].split(',')
    tagIds = getTagId(tagNames)
    insert_record = {
      title:    row[1], 
      img_url:    row[2], 
      recipe_url:    row[3], 
      key:    row[5]
    }
    tagIds.unshift(row[1])
    insert_records << insert_record
    all_tagIds << tagIds
  end
  return insert_records, all_tagIds
end

# 一括でinsertしてからcommit
def externalTransaction(records)
  start_time = Time.now
  ActiveRecord::Base.transaction do
    ExternalSite.create(records)
  end
  "transaction: #{Time.now - start_time}s"
end

def tagMapTransaction(id_records)
  start_time = Time.now
  ActiveRecord::Base.transaction do
    #TagMap.create(id_records)
    ExtagMap.create(id_records)
  end
  "transaction: #{Time.now - start_time}s"
end

def cteateInsertTagArray(all_tagIds)
  insert_tagIds = []
  all_tagIds.each do |tag_ids|
    external_site = ExternalSite.find_by(title: tag_ids[0])
    tag_ids.shift()

    tag_ids.each do |tag_id|
      insert_record = { 
        #tomorecipe_id:    nil, 
        tag_id:           tag_id, 
        external_site_id: external_site.id
      }
      insert_tagIds << insert_record
    end
  end
  return insert_tagIds
end

def main()
  records, all_tagIds = csv_to_records('sick_scraping.csv')
  externalTransaction(records)
  id_records = cteateInsertTagArray(all_tagIds)
  tagMapTransaction(id_records)

  # records, all_tagIds = csv_to_records('allergy_scraping.csv')
  # externalTransaction(records)
  # id_records = cteateInsertTagArray(all_tagIds)
  # tagMapTransaction(id_records)

  # records, all_tagIds = csv_to_records('weak_scraping.csv')
  # externalTransaction(records)
  # id_records = cteateInsertTagArray(all_tagIds)
  # tagMapTransaction(id_records)

  records, all_tagIds = csv_to_records('others_scraping.csv')
  externalTransaction(records)
  id_records = cteateInsertTagArray(all_tagIds)
  tagMapTransaction(id_records)
end

if __FILE__ == $0
  main()
end
