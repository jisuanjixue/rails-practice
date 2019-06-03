class AddRoleToUsers < ActiveRecord::Migration[5.0]
  def change
    # 在之前的课程中，是用 is_admin:boolean 字段来表示是不是管理员，在这里改用 role:string，这样的好处是可以有角色扩充的弹性。
    add_column :users, :role, :string
  end
end
