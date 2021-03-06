class Auto < ActiveRecord::Base
  scope :recent, -> {order(created_at: :desc)}

  belongs_to :user

  class << self
    def get_auto_data id
      ServerApi.call "get", "auto_submodels", { entry_id: id }
    end

    def api_find id
      data = Auto.get_auto_data(id)
      Auto.new brand: data["brand"], series: data["model"], model_number: data["name"], system_id: data["_id"], logo: data['logo']
    end

    def up_autos #更新 auto logo 数据迁移 可删除
      Auto.all.each do |auto|
        if auto.logo.blank?
          if auto.system_id
            begin
              data = Auto.get_auto_data(auto.system_id)
              auto.update(logo: data['logo'])
            rescue
              next
            end
          end
        end
      end;nil #取消返回值
    end
  end

  def full_name
    "#{ brand }#{ series }#{ model_number }"
  end
end
