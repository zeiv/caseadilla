roles = Role.create [
  { title: 'admin' },
  { title: 'user' }
] if Role.count == 0
