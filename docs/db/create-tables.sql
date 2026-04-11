-- ============================================================
-- Database: harness-contents
-- Description: 사용자 및 공통코드 관리 테이블
-- ============================================================

-- ============================================================
-- 1. USERS TABLE (사용자 테이블)
-- ============================================================

-- SEQUENCE 생성
CREATE SEQUENCE seq_users
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  CACHE 1;

-- 테이블 생성
CREATE TABLE users (
  users_seq BIGINT PRIMARY KEY DEFAULT nextval('seq_users'),
  id VARCHAR(50) NOT NULL,
  pw VARCHAR(100) NOT NULL,
  name VARCHAR(50) NOT NULL,
  is_admin CHAR(1) DEFAULT 'N' NOT NULL,
  is_deleted CHAR(1) DEFAULT 'N' NOT NULL,
  deleted_at TIMESTAMP,
  created_by INT NOT NULL,
  created_at TIMESTAMP NOT NULL,
  updated_by INT,
  updated_at TIMESTAMP,
  CONSTRAINT uni_users UNIQUE (id)
);

-- 테이블 코멘트
COMMENT ON TABLE users IS '사용자 계정 및 인증 정보를 관리하는 테이블';

-- 컬럼 코멘트
COMMENT ON COLUMN users.users_seq IS '사용자 고유 식별자';
COMMENT ON COLUMN users.id IS '회원 ID';
COMMENT ON COLUMN users.pw IS '회원 비밀번호';
COMMENT ON COLUMN users.name IS '회원명';
COMMENT ON COLUMN users.is_admin IS '관리자 여부 (Y/N)';
COMMENT ON COLUMN users.is_deleted IS '삭제 여부 (Y/N)';
COMMENT ON COLUMN users.deleted_at IS '삭제 일시';
COMMENT ON COLUMN users.created_by IS '작성자 ID';
COMMENT ON COLUMN users.created_at IS '작성 일시';
COMMENT ON COLUMN users.updated_by IS '수정자 ID';
COMMENT ON COLUMN users.updated_at IS '수정 일시';

-- 인덱스 생성
CREATE INDEX idx_users ON users(id);

-- ============================================================
-- 2. COMMON_CODES TABLE (공통코드 테이블)
-- ============================================================

-- SEQUENCE 생성
CREATE SEQUENCE seq_common_codes
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  CACHE 1;

-- 테이블 생성
CREATE TABLE common_codes (
  common_codes_seq BIGINT PRIMARY KEY DEFAULT nextval('seq_common_codes'),
  code_name VARCHAR(50) NOT NULL,
  code_value VARCHAR(200) NOT NULL,
  is_group_yn CHAR(1) NOT NULL,
  order_seq INT NOT NULL DEFAULT 0,
  is_deleted CHAR(1) DEFAULT 'N' NOT NULL,
  deleted_at TIMESTAMP,
  created_by INT NOT NULL,
  created_at TIMESTAMP NOT NULL,
  updated_by INT,
  updated_at TIMESTAMP,
  CONSTRAINT uni_common_codes UNIQUE (code_name, code_value)
);

-- 테이블 코멘트
COMMENT ON TABLE common_codes IS '시스템에서 사용하는 공통 코드 및 코드값을 관리하는 테이블. 그룹 코드와 상세 코드를 모두 관리 가능';

-- 컬럼 코멘트
COMMENT ON COLUMN common_codes.common_codes_seq IS '공통코드 고유 식별자';
COMMENT ON COLUMN common_codes.code_name IS '코드 명';
COMMENT ON COLUMN common_codes.code_value IS '코드 값';
COMMENT ON COLUMN common_codes.is_group_yn IS '그룹코드 여부 (Y/N)';
COMMENT ON COLUMN common_codes.order_seq IS '코드 순서 정렬 지정';
COMMENT ON COLUMN common_codes.is_deleted IS '삭제 여부 (Y/N)';
COMMENT ON COLUMN common_codes.deleted_at IS '삭제 일시';
COMMENT ON COLUMN common_codes.created_by IS '작성자 ID';
COMMENT ON COLUMN common_codes.created_at IS '작성 일시';
COMMENT ON COLUMN common_codes.updated_by IS '수정자 ID';
COMMENT ON COLUMN common_codes.updated_at IS '수정 일시';

-- 인덱스 생성
CREATE INDEX idx_common_codes ON common_codes(code_name, code_value);

-- ============================================================
-- 3. ADMIN_MENUS TABLE (관리자 메뉴 테이블)
-- ============================================================

-- SEQUENCE 생성
CREATE SEQUENCE seq_admin_menus
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  CACHE 1;

-- 테이블 생성
CREATE TABLE admin_menus (
  admin_menus_seq BIGINT PRIMARY KEY DEFAULT nextval('seq_admin_menus'),
  parent_seq BIGINT,
  menu_name VARCHAR(100) NOT NULL,
  menu_url VARCHAR(255),
  menu_icon VARCHAR(100),
  menu_depth INT NOT NULL DEFAULT 1,
  order_seq INT NOT NULL DEFAULT 0,
  is_active CHAR(1) DEFAULT 'Y' NOT NULL,
  is_deleted CHAR(1) DEFAULT 'N' NOT NULL,
  deleted_at TIMESTAMP,
  created_by INT NOT NULL,
  created_at TIMESTAMP NOT NULL,
  updated_by INT,
  updated_at TIMESTAMP
);

-- 테이블 코멘트
COMMENT ON TABLE admin_menus IS '관리자 페이지 메뉴를 관리하는 테이블 (2-depth 자기참조 구조)';

-- 컬럼 코멘트
COMMENT ON COLUMN admin_menus.admin_menus_seq IS '메뉴 고유 식별자';
COMMENT ON COLUMN admin_menus.parent_seq IS '상위 메뉴 식별자 (1depth는 NULL)';
COMMENT ON COLUMN admin_menus.menu_name IS '메뉴명';
COMMENT ON COLUMN admin_menus.menu_url IS '메뉴 URL (2depth만 사용)';
COMMENT ON COLUMN admin_menus.menu_icon IS '메뉴 아이콘 클래스명';
COMMENT ON COLUMN admin_menus.menu_depth IS '메뉴 깊이 (1 또는 2)';
COMMENT ON COLUMN admin_menus.order_seq IS '정렬 순서';
COMMENT ON COLUMN admin_menus.is_active IS '활성 여부 (Y/N)';
COMMENT ON COLUMN admin_menus.is_deleted IS '삭제 여부 (Y/N)';
COMMENT ON COLUMN admin_menus.deleted_at IS '삭제 일시';
COMMENT ON COLUMN admin_menus.created_by IS '작성자 ID';
COMMENT ON COLUMN admin_menus.created_at IS '작성 일시';
COMMENT ON COLUMN admin_menus.updated_by IS '수정자 ID';
COMMENT ON COLUMN admin_menus.updated_at IS '수정 일시';

-- 인덱스 생성
CREATE INDEX idx_admin_menus ON admin_menus(parent_seq, order_seq);

-- ============================================================
-- 4. ADMIN_ROLES TABLE (관리자 역할 테이블)
-- ============================================================

-- SEQUENCE 생성
CREATE SEQUENCE seq_admin_roles
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  CACHE 1;

-- 테이블 생성
CREATE TABLE admin_roles (
  admin_roles_seq BIGINT PRIMARY KEY DEFAULT nextval('seq_admin_roles'),
  role_name VARCHAR(50) NOT NULL,
  role_description VARCHAR(255),
  is_deleted CHAR(1) DEFAULT 'N' NOT NULL,
  deleted_at TIMESTAMP,
  created_by INT NOT NULL,
  created_at TIMESTAMP NOT NULL,
  updated_by INT,
  updated_at TIMESTAMP,
  CONSTRAINT uni_admin_roles UNIQUE (role_name)
);

-- 테이블 코멘트
COMMENT ON TABLE admin_roles IS '관리자 역할(권한 그룹)을 정의하는 테이블';

-- 컬럼 코멘트
COMMENT ON COLUMN admin_roles.admin_roles_seq IS '역할 고유 식별자';
COMMENT ON COLUMN admin_roles.role_name IS '역할명 (예: system, cms)';
COMMENT ON COLUMN admin_roles.role_description IS '역할 설명';
COMMENT ON COLUMN admin_roles.is_deleted IS '삭제 여부 (Y/N)';
COMMENT ON COLUMN admin_roles.deleted_at IS '삭제 일시';
COMMENT ON COLUMN admin_roles.created_by IS '작성자 ID';
COMMENT ON COLUMN admin_roles.created_at IS '작성 일시';
COMMENT ON COLUMN admin_roles.updated_by IS '수정자 ID';
COMMENT ON COLUMN admin_roles.updated_at IS '수정 일시';

-- 인덱스 생성
CREATE INDEX idx_admin_roles ON admin_roles(role_name);

-- ============================================================
-- 5. ADMIN_ROLE_USERS TABLE (역할-사용자 매핑 테이블)
-- ============================================================

-- SEQUENCE 생성
CREATE SEQUENCE seq_admin_role_users
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  CACHE 1;

-- 테이블 생성
CREATE TABLE admin_role_users (
  admin_role_users_seq BIGINT PRIMARY KEY DEFAULT nextval('seq_admin_role_users'),
  admin_roles_seq BIGINT NOT NULL,  -- FK reference (admin_roles 테이블)
  users_seq BIGINT NOT NULL,        -- FK reference (users 테이블)
  is_deleted CHAR(1) DEFAULT 'N' NOT NULL,
  deleted_at TIMESTAMP,
  created_by INT NOT NULL,
  created_at TIMESTAMP NOT NULL,
  updated_by INT,
  updated_at TIMESTAMP,
  CONSTRAINT uni_admin_role_users UNIQUE (admin_roles_seq, users_seq)
);

-- 테이블 코멘트
COMMENT ON TABLE admin_role_users IS '관리자 역할과 사용자 간의 매핑 테이블';

-- 컬럼 코멘트
COMMENT ON COLUMN admin_role_users.admin_role_users_seq IS '역할-사용자 매핑 고유 식별자';
COMMENT ON COLUMN admin_role_users.admin_roles_seq IS '역할 식별자 (admin_roles 참조)';
COMMENT ON COLUMN admin_role_users.users_seq IS '사용자 식별자 (users 참조)';
COMMENT ON COLUMN admin_role_users.is_deleted IS '삭제 여부 (Y/N)';
COMMENT ON COLUMN admin_role_users.deleted_at IS '삭제 일시';
COMMENT ON COLUMN admin_role_users.created_by IS '작성자 ID';
COMMENT ON COLUMN admin_role_users.created_at IS '작성 일시';
COMMENT ON COLUMN admin_role_users.updated_by IS '수정자 ID';
COMMENT ON COLUMN admin_role_users.updated_at IS '수정 일시';

-- 인덱스 생성
CREATE INDEX idx_admin_role_users ON admin_role_users(admin_roles_seq, users_seq);

-- ============================================================
-- 6. ADMIN_ROLE_MENUS TABLE (역할-메뉴 매핑 테이블)
-- ============================================================

-- SEQUENCE 생성
CREATE SEQUENCE seq_admin_role_menus
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  CACHE 1;

-- 테이블 생성
CREATE TABLE admin_role_menus (
  admin_role_menus_seq BIGINT PRIMARY KEY DEFAULT nextval('seq_admin_role_menus'),
  admin_roles_seq BIGINT NOT NULL,  -- FK reference (admin_roles 테이블)
  admin_menus_seq BIGINT NOT NULL,  -- FK reference (admin_menus 테이블)
  is_deleted CHAR(1) DEFAULT 'N' NOT NULL,
  deleted_at TIMESTAMP,
  created_by INT NOT NULL,
  created_at TIMESTAMP NOT NULL,
  updated_by INT,
  updated_at TIMESTAMP,
  CONSTRAINT uni_admin_role_menus UNIQUE (admin_roles_seq, admin_menus_seq)
);

-- 테이블 코멘트
COMMENT ON TABLE admin_role_menus IS '관리자 역할과 메뉴 간의 접근 권한 매핑 테이블';

-- 컬럼 코멘트
COMMENT ON COLUMN admin_role_menus.admin_role_menus_seq IS '역할-메뉴 매핑 고유 식별자';
COMMENT ON COLUMN admin_role_menus.admin_roles_seq IS '역할 식별자 (admin_roles 참조)';
COMMENT ON COLUMN admin_role_menus.admin_menus_seq IS '메뉴 식별자 (admin_menus 참조)';
COMMENT ON COLUMN admin_role_menus.is_deleted IS '삭제 여부 (Y/N)';
COMMENT ON COLUMN admin_role_menus.deleted_at IS '삭제 일시';
COMMENT ON COLUMN admin_role_menus.created_by IS '작성자 ID';
COMMENT ON COLUMN admin_role_menus.created_at IS '작성 일시';
COMMENT ON COLUMN admin_role_menus.updated_by IS '수정자 ID';
COMMENT ON COLUMN admin_role_menus.updated_at IS '수정 일시';

-- 인덱스 생성
CREATE INDEX idx_admin_role_menus ON admin_role_menus(admin_roles_seq, admin_menus_seq);

-- ============================================================
-- 7. ATTACHMENTS TABLE (첨부파일 마스터 테이블)
-- ============================================================

-- SEQUENCE 생성
CREATE SEQUENCE seq_attachments
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  CACHE 1;

-- 테이블 생성
CREATE TABLE attachments (
  attachments_seq BIGINT PRIMARY KEY DEFAULT nextval('seq_attachments'),
  target_table VARCHAR(100) NOT NULL,
  target_seq BIGINT NOT NULL,
  is_deleted CHAR(1) DEFAULT 'N' NOT NULL,
  deleted_at TIMESTAMP,
  created_by INT NOT NULL,
  created_at TIMESTAMP NOT NULL,
  updated_by INT,
  updated_at TIMESTAMP
);

-- 테이블 코멘트
COMMENT ON TABLE attachments IS '첨부파일 마스터 테이블. 대상 테이블과 대상 PK를 기준으로 첨부파일 그룹을 관리';

-- 컬럼 코멘트
COMMENT ON COLUMN attachments.attachments_seq IS '첨부파일 마스터 고유 식별자';
COMMENT ON COLUMN attachments.target_table IS '첨부 대상 테이블명 (예: users, admin_menus)';
COMMENT ON COLUMN attachments.target_seq IS '첨부 대상 테이블의 PK 값';
COMMENT ON COLUMN attachments.is_deleted IS '삭제 여부 (Y/N)';
COMMENT ON COLUMN attachments.deleted_at IS '삭제 일시';
COMMENT ON COLUMN attachments.created_by IS '작성자 ID';
COMMENT ON COLUMN attachments.created_at IS '작성 일시';
COMMENT ON COLUMN attachments.updated_by IS '수정자 ID';
COMMENT ON COLUMN attachments.updated_at IS '수정 일시';

-- 인덱스 생성
CREATE INDEX idx_attachments ON attachments(target_table, target_seq);

-- ============================================================
-- 8. ATTACHMENT_FILES TABLE (첨부파일 상세 테이블)
-- ============================================================

-- SEQUENCE 생성
CREATE SEQUENCE seq_attachment_files
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  CACHE 1;

-- 테이블 생성
CREATE TABLE attachment_files (
  attachment_files_seq BIGINT PRIMARY KEY DEFAULT nextval('seq_attachment_files'),
  attachments_seq BIGINT NOT NULL,
  original_name VARCHAR(500) NOT NULL,
  stored_name VARCHAR(500) NOT NULL,
  file_path VARCHAR(1000) NOT NULL,
  file_size BIGINT NOT NULL DEFAULT 0,
  file_ext VARCHAR(50),
  mime_type VARCHAR(200),
  order_seq INT NOT NULL DEFAULT 0,
  is_deleted CHAR(1) DEFAULT 'N' NOT NULL,
  deleted_at TIMESTAMP,
  created_by INT NOT NULL,
  created_at TIMESTAMP NOT NULL,
  updated_by INT,
  updated_at TIMESTAMP,
  CONSTRAINT uni_attachment_files UNIQUE (attachment_files_seq, attachments_seq)
);

-- 테이블 코멘트
COMMENT ON TABLE attachment_files IS '첨부파일 상세 테이블. 하나의 마스터(attachments)에 여러 개의 파일이 매핑되는 구조';

-- 컬럼 코멘트
COMMENT ON COLUMN attachment_files.attachment_files_seq IS '첨부파일 상세 고유 식별자';
COMMENT ON COLUMN attachment_files.attachments_seq IS '첨부파일 마스터 식별자 (attachments 참조)';
COMMENT ON COLUMN attachment_files.original_name IS '원본 파일명';
COMMENT ON COLUMN attachment_files.stored_name IS '저장 파일명 (UUID 등 중복 방지용)';
COMMENT ON COLUMN attachment_files.file_path IS '파일 저장 경로';
COMMENT ON COLUMN attachment_files.file_size IS '파일 크기 (bytes)';
COMMENT ON COLUMN attachment_files.file_ext IS '파일 확장자 (예: jpg, pdf, xlsx)';
COMMENT ON COLUMN attachment_files.mime_type IS 'MIME 타입 (예: image/png, application/pdf)';
COMMENT ON COLUMN attachment_files.order_seq IS '파일 정렬 순서';
COMMENT ON COLUMN attachment_files.is_deleted IS '삭제 여부 (Y/N)';
COMMENT ON COLUMN attachment_files.deleted_at IS '삭제 일시';
COMMENT ON COLUMN attachment_files.created_by IS '작성자 ID';
COMMENT ON COLUMN attachment_files.created_at IS '작성 일시';
COMMENT ON COLUMN attachment_files.updated_by IS '수정자 ID';
COMMENT ON COLUMN attachment_files.updated_at IS '수정 일시';

-- 인덱스 생성
CREATE INDEX idx_attachment_files ON attachment_files(attachments_seq, order_seq);

-- ============================================================
-- 9. INITIAL DATA (초기 데이터)
-- ============================================================

/*
-- 초기 관리자 계정
INSERT INTO users (id, pw, name, is_admin, is_deleted, created_by, created_at)
VALUES ('admin', 'admin1234', '관리자', 'Y', 'N', 1, NOW());

-- 역할 정의
INSERT INTO admin_roles (role_name, role_description, is_deleted, created_by, created_at)
VALUES ('system', '전체 권한 (시스템 관리 포함)', 'N', 1, NOW());
INSERT INTO admin_roles (role_name, role_description, is_deleted, created_by, created_at)
VALUES ('cms', '콘텐츠 관리 권한 (시스템 메뉴 제외)', 'N', 1, NOW());

-- 메뉴: 1depth (대메뉴)
INSERT INTO admin_menus (menu_name, menu_url, menu_icon, menu_depth, order_seq, is_active, is_deleted, created_by, created_at)
VALUES ('대시보드', NULL, 'mdi-view-dashboard', 1, 1, 'Y', 'N', 1, NOW());
INSERT INTO admin_menus (menu_name, menu_url, menu_icon, menu_depth, order_seq, is_active, is_deleted, created_by, created_at)
VALUES ('회원 관리', NULL, 'mdi-account-group', 1, 2, 'Y', 'N', 1, NOW());
INSERT INTO admin_menus (menu_name, menu_url, menu_icon, menu_depth, order_seq, is_active, is_deleted, created_by, created_at)
VALUES ('시스템 관리', NULL, 'mdi-cog', 1, 3, 'Y', 'N', 1, NOW());

-- 메뉴: 2depth (소메뉴) - parent_seq는 실제 생성된 1depth PK에 맞게 조정 필요
-- 대시보드 > 대시보드 (parent_seq = 1)
INSERT INTO admin_menus (parent_seq, menu_name, menu_url, menu_icon, menu_depth, order_seq, is_active, is_deleted, created_by, created_at)
VALUES (1, '대시보드', '/', NULL, 2, 1, 'Y', 'N', 1, NOW());
-- 회원 관리 > 회원 목록 (parent_seq = 2)
INSERT INTO admin_menus (parent_seq, menu_name, menu_url, menu_icon, menu_depth, order_seq, is_active, is_deleted, created_by, created_at)
VALUES (2, '회원 목록', '/member/list', NULL, 2, 1, 'Y', 'N', 1, NOW());
-- 시스템 관리 > 메뉴 관리 (parent_seq = 3)
INSERT INTO admin_menus (parent_seq, menu_name, menu_url, menu_icon, menu_depth, order_seq, is_active, is_deleted, created_by, created_at)
VALUES (3, '메뉴 관리', '/system/menus', NULL, 2, 1, 'Y', 'N', 1, NOW());
-- 시스템 관리 > 권한 관리 (parent_seq = 3)
INSERT INTO admin_menus (parent_seq, menu_name, menu_url, menu_icon, menu_depth, order_seq, is_active, is_deleted, created_by, created_at)
VALUES (3, '권한 관리', '/system/roles', NULL, 2, 2, 'Y', 'N', 1, NOW());
-- 시스템 관리 > 공통코드 관리 (parent_seq = 3)
INSERT INTO admin_menus (parent_seq, menu_name, menu_url, menu_icon, menu_depth, order_seq, is_active, is_deleted, created_by, created_at)
VALUES (3, '공통코드 관리', '/system/codes', NULL, 2, 3, 'Y', 'N', 1, NOW());

-- 역할-사용자 매핑: admin 계정에 system 역할 부여
INSERT INTO admin_role_users (admin_roles_seq, users_seq, is_deleted, created_by, created_at)
VALUES (1, 1, 'N', 1, NOW());

-- 역할-메뉴 매핑: system 역할 (전체 메뉴 접근)
INSERT INTO admin_role_menus (admin_roles_seq, admin_menus_seq, is_deleted, created_by, created_at)
VALUES (1, 1, 'N', 1, NOW());
INSERT INTO admin_role_menus (admin_roles_seq, admin_menus_seq, is_deleted, created_by, created_at)
VALUES (1, 2, 'N', 1, NOW());
INSERT INTO admin_role_menus (admin_roles_seq, admin_menus_seq, is_deleted, created_by, created_at)
VALUES (1, 3, 'N', 1, NOW());
INSERT INTO admin_role_menus (admin_roles_seq, admin_menus_seq, is_deleted, created_by, created_at)
VALUES (1, 4, 'N', 1, NOW());
INSERT INTO admin_role_menus (admin_roles_seq, admin_menus_seq, is_deleted, created_by, created_at)
VALUES (1, 5, 'N', 1, NOW());
INSERT INTO admin_role_menus (admin_roles_seq, admin_menus_seq, is_deleted, created_by, created_at)
VALUES (1, 6, 'N', 1, NOW());
INSERT INTO admin_role_menus (admin_roles_seq, admin_menus_seq, is_deleted, created_by, created_at)
VALUES (1, 7, 'N', 1, NOW());
INSERT INTO admin_role_menus (admin_roles_seq, admin_menus_seq, is_deleted, created_by, created_at)
VALUES (1, 8, 'N', 1, NOW());

-- 역할-메뉴 매핑: cms 역할 (시스템 관리 제외)
INSERT INTO admin_role_menus (admin_roles_seq, admin_menus_seq, is_deleted, created_by, created_at)
VALUES (2, 1, 'N', 1, NOW());
INSERT INTO admin_role_menus (admin_roles_seq, admin_menus_seq, is_deleted, created_by, created_at)
VALUES (2, 2, 'N', 1, NOW());
INSERT INTO admin_role_menus (admin_roles_seq, admin_menus_seq, is_deleted, created_by, created_at)
VALUES (2, 4, 'N', 1, NOW());
INSERT INTO admin_role_menus (admin_roles_seq, admin_menus_seq, is_deleted, created_by, created_at)
VALUES (2, 5, 'N', 1, NOW());
*/

-- ============================================================
-- 10. CONSTRAINTS VERIFICATION
-- ============================================================

-- Constraint 확인
SELECT constraint_name, constraint_type, table_name
FROM information_schema.table_constraints
WHERE table_name IN ('users', 'common_codes', 'admin_menus', 'admin_roles', 'admin_role_users', 'admin_role_menus', 'attachments', 'attachment_files')
ORDER BY table_name, constraint_name;

-- ============================================================
-- 11. SEQUENCE VERIFICATION
-- ============================================================

-- SEQUENCE 확인
SELECT sequence_name, start_value, increment_by, cache_size
FROM information_schema.sequences
WHERE sequence_name IN ('seq_users', 'seq_common_codes', 'seq_admin_menus', 'seq_admin_roles', 'seq_admin_role_users', 'seq_admin_role_menus', 'seq_attachments', 'seq_attachment_files')
ORDER BY sequence_name;

-- ============================================================
-- 12. TABLE & COLUMN COMMENTS VERIFICATION
-- ============================================================

-- 테이블 코멘트 확인
SELECT table_name, obj_description(('public.' || table_name)::regclass, 'pg_class') AS table_comment
FROM information_schema.tables
WHERE table_schema = 'public' AND table_name IN ('users', 'common_codes', 'admin_menus', 'admin_roles', 'admin_role_users', 'admin_role_menus', 'attachments', 'attachment_files')
ORDER BY table_name;

-- 컬럼 코멘트 확인
SELECT table_name, column_name, col_description((table_name)::regclass, ordinal_position) AS column_comment
FROM information_schema.columns
WHERE table_schema = 'public' AND table_name IN ('users', 'common_codes', 'admin_menus', 'admin_roles', 'admin_role_users', 'admin_role_menus', 'attachments', 'attachment_files')
ORDER BY table_name, ordinal_position;
