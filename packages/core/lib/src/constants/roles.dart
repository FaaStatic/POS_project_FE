enum UserRole {
  superadmin,
  staff;

  static UserRole parse(String raw) => switch (raw.toLowerCase()) {
        'superadmin' || 'super' || '0' => UserRole.superadmin,
        _ => UserRole.staff,
      };

  bool get isSuper => this == UserRole.superadmin;
}
