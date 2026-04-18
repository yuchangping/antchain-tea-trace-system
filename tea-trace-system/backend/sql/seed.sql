USE tea_trace_system;

-- Default plaintext password for demo accounts: abc
-- The hash below is a bcrypt hash and can be verified by bcrypt or bcryptjs.

INSERT INTO users (username, password, role, real_name, company_name, status)
VALUES
  ('admin', '$2a$10$OrKdcWORLL8Gorhy9XR3UOY8Sebzq92m7r02XPitzoazPdO7tmsEO', 'admin', 'System Admin', 'Platform Center', 1),
  ('producer01', '$2a$10$OrKdcWORLL8Gorhy9XR3UOY8Sebzq92m7r02XPitzoazPdO7tmsEO', 'producer', 'Tea Producer', 'High Mountain Tea Farm', 1),
  ('logistics01', '$2a$10$OrKdcWORLL8Gorhy9XR3UOY8Sebzq92m7r02XPitzoazPdO7tmsEO', 'logistics', 'Logistics Staff', 'Tea Logistics Co', 1),
  ('seller01', '$2a$10$OrKdcWORLL8Gorhy9XR3UOY8Sebzq92m7r02XPitzoazPdO7tmsEO', 'seller', 'Sales Staff', 'Tea Store', 1)
ON DUPLICATE KEY UPDATE
  password = VALUES(password),
  role = VALUES(role),
  real_name = VALUES(real_name),
  company_name = VALUES(company_name),
  status = VALUES(status),
  updated_at = CURRENT_TIMESTAMP;
