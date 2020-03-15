unless User.admins.any?
  User.create!(
    email: 'admin@forum.lxkuz',
    password: 'forumadmin',
    role: :admin
  )
end
