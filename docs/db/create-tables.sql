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

-- 인덱스: UNIQUE(id)가 자동 생성하므로 별도 인덱스 불필요

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
  code_group VARCHAR(50) NOT NULL,
  code_value VARCHAR(50) NOT NULL,
  code_name VARCHAR(200) NOT NULL,
  order_seq INT NOT NULL DEFAULT 0,
  is_deleted CHAR(1) DEFAULT 'N' NOT NULL,
  deleted_at TIMESTAMP,
  created_by INT NOT NULL,
  created_at TIMESTAMP NOT NULL,
  updated_by INT,
  updated_at TIMESTAMP,
  CONSTRAINT uni_common_codes UNIQUE (code_group, code_value)
);

-- 테이블 코멘트
COMMENT ON TABLE common_codes IS '시스템에서 사용하는 공통 코드 및 코드값을 관리하는 테이블. code_group = code_value이면 그룹코드';

-- 컬럼 코멘트
COMMENT ON COLUMN common_codes.common_codes_seq IS '공통코드 고유 식별자';
COMMENT ON COLUMN common_codes.code_group IS '코드 그룹 (그룹코드일 때 code_value와 동일)';
COMMENT ON COLUMN common_codes.code_value IS '코드 값 (영문 식별자)';
COMMENT ON COLUMN common_codes.code_name IS '코드 표시명 (한글 등)';
COMMENT ON COLUMN common_codes.order_seq IS '코드 순서 정렬 지정';
COMMENT ON COLUMN common_codes.is_deleted IS '삭제 여부 (Y/N)';
COMMENT ON COLUMN common_codes.deleted_at IS '삭제 일시';
COMMENT ON COLUMN common_codes.created_by IS '작성자 ID';
COMMENT ON COLUMN common_codes.created_at IS '작성 일시';
COMMENT ON COLUMN common_codes.updated_by IS '수정자 ID';
COMMENT ON COLUMN common_codes.updated_at IS '수정 일시';

-- 인덱스: UNIQUE(code_group, code_value)가 자동 생성하므로 별도 인덱스 불필요

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

-- 인덱스: UNIQUE(role_name)가 자동 생성하므로 별도 인덱스 불필요

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

-- 인덱스: UNIQUE(admin_roles_seq, users_seq)가 자동 생성하므로 별도 인덱스 불필요

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

-- 인덱스: UNIQUE(admin_roles_seq, admin_menus_seq)가 자동 생성하므로 별도 인덱스 불필요

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
-- 9. AI_PROMPT_CONTENTS TABLE (AI 프롬프트 게시판 테이블)
-- ============================================================

-- SEQUENCE 생성
CREATE SEQUENCE seq_ai_prompt_contents
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  CACHE 1;

-- 테이블 생성
CREATE TABLE ai_prompt_contents (
  ai_prompt_contents_seq BIGINT PRIMARY KEY DEFAULT nextval('seq_ai_prompt_contents'),
  title VARCHAR(50) NOT NULL,
  intro VARCHAR(200),
  prompt_content TEXT NOT NULL,
  category_code VARCHAR(50) NOT NULL,
  avatar_emoji VARCHAR(20) NOT NULL,
  avatar_color VARCHAR(100) NOT NULL,
  is_deleted CHAR(1) DEFAULT 'N' NOT NULL,
  deleted_at TIMESTAMP,
  created_by INT NOT NULL,
  created_at TIMESTAMP NOT NULL,
  updated_by INT,
  updated_at TIMESTAMP
);

-- 테이블 코멘트
COMMENT ON TABLE ai_prompt_contents IS 'AI 페르소나 프롬프트를 관리하는 게시판 테이블. LLM 대화 시 system prompt(instructions)로 사용';

-- 컬럼 코멘트
COMMENT ON COLUMN ai_prompt_contents.ai_prompt_contents_seq IS 'AI 프롬프트 고유 식별자';
COMMENT ON COLUMN ai_prompt_contents.title IS '프롬프트 제목 (예: 어린왕자, 우영우 변호사)';
COMMENT ON COLUMN ai_prompt_contents.intro IS '프롬프트 소개글';
COMMENT ON COLUMN ai_prompt_contents.prompt_content IS 'LLM에 전달할 system prompt 본문';
COMMENT ON COLUMN ai_prompt_contents.category_code IS 'AI 카테고리 코드 (common_codes: code_group=ai_category의 code_value)';
COMMENT ON COLUMN ai_prompt_contents.avatar_emoji IS '아바타 이모지 (예: 👑, ⚖️)';
COMMENT ON COLUMN ai_prompt_contents.avatar_color IS '아바타 배경 CSS (예: linear-gradient(135deg, #ffd54f, #ffb300))';
COMMENT ON COLUMN ai_prompt_contents.is_deleted IS '삭제 여부 (Y/N)';
COMMENT ON COLUMN ai_prompt_contents.deleted_at IS '삭제 일시';
COMMENT ON COLUMN ai_prompt_contents.created_by IS '작성자 ID';
COMMENT ON COLUMN ai_prompt_contents.created_at IS '작성 일시';
COMMENT ON COLUMN ai_prompt_contents.updated_by IS '수정자 ID';
COMMENT ON COLUMN ai_prompt_contents.updated_at IS '수정 일시';


-- ============================================================
-- 10. INITIAL DATA (초기 데이터)
-- ============================================================

-- 기존 데이터 초기화 (FK 의존 순서: 자식 → 부모)
TRUNCATE TABLE admin_role_menus RESTART IDENTITY CASCADE;
TRUNCATE TABLE admin_role_users RESTART IDENTITY CASCADE;
TRUNCATE TABLE admin_roles RESTART IDENTITY CASCADE;
TRUNCATE TABLE admin_menus RESTART IDENTITY CASCADE;
TRUNCATE TABLE attachment_files RESTART IDENTITY CASCADE;
TRUNCATE TABLE attachments RESTART IDENTITY CASCADE;
TRUNCATE TABLE common_codes RESTART IDENTITY CASCADE;
TRUNCATE TABLE ai_prompt_contents RESTART IDENTITY CASCADE;
TRUNCATE TABLE users RESTART IDENTITY CASCADE;

-- 초기 관리자 계정
-- admin / admin1234
INSERT INTO users (id, pw, name, is_admin, is_deleted, created_by, created_at)
VALUES ('admin', '$2a$10$jB4h7H2bGIxB5ejjPe0ZGe5NiYfrzQw1Axve0Rnwg0xVQHzwE.bKy', '관리자', 'Y', 'N', currval('seq_users'), NOW());

-- 역할 정의
INSERT INTO admin_roles (role_name, role_description, is_deleted, created_by, created_at)
VALUES ('system', '전체 권한 (시스템 관리 포함)', 'N', currval('seq_users'), NOW());
INSERT INTO admin_roles (role_name, role_description, is_deleted, created_by, created_at)
VALUES ('cms', '콘텐츠 관리 권한 (시스템 메뉴 제외)', 'N', currval('seq_users'), NOW());

-- 메뉴: 1depth (대메뉴)
INSERT INTO admin_menus (menu_name, menu_url, menu_icon, menu_depth, order_seq, is_active, is_deleted, created_by, created_at)
VALUES ('대시보드', NULL, 'mdi-view-dashboard', 1, 1, 'Y', 'N', currval('seq_users'), NOW());
INSERT INTO admin_menus (menu_name, menu_url, menu_icon, menu_depth, order_seq, is_active, is_deleted, created_by, created_at)
VALUES ('회원 관리', NULL, 'mdi-account-group', 1, 2, 'Y', 'N', currval('seq_users'), NOW());
INSERT INTO admin_menus (menu_name, menu_url, menu_icon, menu_depth, order_seq, is_active, is_deleted, created_by, created_at)
VALUES ('시스템 관리', NULL, 'mdi-cog', 1, 4, 'Y', 'N', currval('seq_users'), NOW());
INSERT INTO admin_menus (menu_name, menu_url, menu_icon, menu_depth, order_seq, is_active, is_deleted, created_by, created_at)
VALUES ('콘텐츠', NULL, 'mdi-text-box-multiple-outline', 1, 3, 'Y', 'N', currval('seq_users'), NOW());

-- 메뉴: 2depth (소메뉴) - parent_seq는 서브쿼리로 1depth PK 참조
-- 대시보드 > 대시보드
INSERT INTO admin_menus (parent_seq, menu_name, menu_url, menu_icon, menu_depth, order_seq, is_active, is_deleted, created_by, created_at)
VALUES ((SELECT admin_menus_seq FROM admin_menus WHERE menu_name = '대시보드' AND menu_depth = 1 AND is_deleted = 'N'), '대시보드', '/', NULL, 2, 1, 'Y', 'N', currval('seq_users'), NOW());
-- 회원 관리 > 회원 목록
INSERT INTO admin_menus (parent_seq, menu_name, menu_url, menu_icon, menu_depth, order_seq, is_active, is_deleted, created_by, created_at)
VALUES ((SELECT admin_menus_seq FROM admin_menus WHERE menu_name = '회원 관리' AND menu_depth = 1 AND is_deleted = 'N'), '회원 목록', '/member/list', NULL, 2, 1, 'Y', 'N', currval('seq_users'), NOW());
-- 시스템 관리 > 메뉴 관리
INSERT INTO admin_menus (parent_seq, menu_name, menu_url, menu_icon, menu_depth, order_seq, is_active, is_deleted, created_by, created_at)
VALUES ((SELECT admin_menus_seq FROM admin_menus WHERE menu_name = '시스템 관리' AND menu_depth = 1 AND is_deleted = 'N'), '메뉴 관리', '/system/menus', NULL, 2, 1, 'Y', 'N', currval('seq_users'), NOW());
-- 시스템 관리 > 권한 관리
INSERT INTO admin_menus (parent_seq, menu_name, menu_url, menu_icon, menu_depth, order_seq, is_active, is_deleted, created_by, created_at)
VALUES ((SELECT admin_menus_seq FROM admin_menus WHERE menu_name = '시스템 관리' AND menu_depth = 1 AND is_deleted = 'N'), '권한 관리', '/system/roles', NULL, 2, 2, 'Y', 'N', currval('seq_users'), NOW());
-- 시스템 관리 > 권한별 메뉴 관리
INSERT INTO admin_menus (parent_seq, menu_name, menu_url, menu_icon, menu_depth, order_seq, is_active, is_deleted, created_by, created_at)
VALUES ((SELECT admin_menus_seq FROM admin_menus WHERE menu_name = '시스템 관리' AND menu_depth = 1 AND is_deleted = 'N'), '권한별 메뉴 관리', '/system/role-menus', NULL, 2, 3, 'Y', 'N', currval('seq_users'), NOW());
-- 시스템 관리 > 공통코드 관리
INSERT INTO admin_menus (parent_seq, menu_name, menu_url, menu_icon, menu_depth, order_seq, is_active, is_deleted, created_by, created_at)
VALUES ((SELECT admin_menus_seq FROM admin_menus WHERE menu_name = '시스템 관리' AND menu_depth = 1 AND is_deleted = 'N'), '공통코드 관리', '/system/codes', NULL, 2, 4, 'Y', 'N', currval('seq_users'), NOW());
-- 콘텐츠 > AI 프롬프트
INSERT INTO admin_menus (parent_seq, menu_name, menu_url, menu_icon, menu_depth, order_seq, is_active, is_deleted, created_by, created_at)
VALUES ((SELECT admin_menus_seq FROM admin_menus WHERE menu_name = '콘텐츠' AND menu_depth = 1 AND is_deleted = 'N'), 'AI 프롬프트', '/content/ai-prompts', NULL, 2, 1, 'Y', 'N', currval('seq_users'), NOW());

-- 역할-사용자 매핑: admin 계정에 system 역할 부여
INSERT INTO admin_role_users (admin_roles_seq, users_seq, is_deleted, created_by, created_at)
VALUES (
  (SELECT admin_roles_seq FROM admin_roles WHERE role_name = 'system' AND is_deleted = 'N'),
  (SELECT users_seq FROM users WHERE id = 'admin' AND is_deleted = 'N'),
  'N', currval('seq_users'), NOW()
);

-- 역할-메뉴 매핑: system 역할 (전체 메뉴 접근)
INSERT INTO admin_role_menus (admin_roles_seq, admin_menus_seq, is_deleted, created_by, created_at)
SELECT
  (SELECT admin_roles_seq FROM admin_roles WHERE role_name = 'system' AND is_deleted = 'N'),
  am.admin_menus_seq,
  'N', currval('seq_users'), NOW()
FROM admin_menus am
WHERE am.is_deleted = 'N';

-- 역할-메뉴 매핑: cms 역할 (시스템 관리 제외 — 대시보드, 회원 관리 1depth + 2depth)
INSERT INTO admin_role_menus (admin_roles_seq, admin_menus_seq, is_deleted, created_by, created_at)
SELECT
  (SELECT admin_roles_seq FROM admin_roles WHERE role_name = 'cms' AND is_deleted = 'N'),
  am.admin_menus_seq,
  'N', currval('seq_users'), NOW()
FROM admin_menus am
WHERE am.is_deleted = 'N'
  AND (
    am.menu_name IN ('대시보드', '회원 관리', '콘텐츠')
    OR am.parent_seq IN (
      SELECT admin_menus_seq FROM admin_menus
      WHERE menu_name IN ('대시보드', '회원 관리', '콘텐츠') AND menu_depth = 1 AND is_deleted = 'N'
    )
  );

-- 공통코드: ai_category (AI 카테고리)
-- code_group = code_value → 그룹코드
INSERT INTO common_codes (code_group, code_value, code_name, order_seq, is_deleted, created_by, created_at)
VALUES ('ai_category', 'ai_category', 'AI 카테고리', 0, 'N', currval('seq_users'), NOW());
INSERT INTO common_codes (code_group, code_value, code_name, order_seq, is_deleted, created_by, created_at)
VALUES ('ai_category', 'philosophy', '철학', 1, 'N', currval('seq_users'), NOW());
INSERT INTO common_codes (code_group, code_value, code_name, order_seq, is_deleted, created_by, created_at)
VALUES ('ai_category', 'law', '법률', 2, 'N', currval('seq_users'), NOW());
INSERT INTO common_codes (code_group, code_value, code_name, order_seq, is_deleted, created_by, created_at)
VALUES ('ai_category', 'cooking', '요리', 3, 'N', currval('seq_users'), NOW());
INSERT INTO common_codes (code_group, code_value, code_name, order_seq, is_deleted, created_by, created_at)
VALUES ('ai_category', 'travel', '여행', 4, 'N', currval('seq_users'), NOW());

-- AI 프롬프트 초기 데이터
INSERT INTO ai_prompt_contents (title, intro, prompt_content, category_code, avatar_emoji, avatar_color, is_deleted, created_by, created_at)
VALUES (
  '어린왕자',
  'B612 소행성에서 온 순수한 영혼의 왕자',
  '당신은 생텍쥐베리의 ''어린 왕자''입니다. 다음 특성을 따라주세요:
1. 순수한 관점으로 세상을 바라봅니다.
2. "어째서?"라는 질문을 자주 하면 호기심이 많습니다.
3. 철학적 통찰을 단순하게 표현합니다.
4. "어른들은 참 이상해요"라는 표현을 씁니다.
5. B-612 소행성에서 왔으며 장미와의 관계를 언급합니다.
6. 여우의 "길들임"과 "책임"에 대한 교훈을 중요시합니다.
7. "중요한 것은 눈에 보이지 않아"라는 문장을 사용합니다.
8. 공손하고 친절한 말투를 사용합니다.
9. 비유와 은유로 복잡한 개념을 설명합니다.
항상 간결하게 답변하세요. 길어야 두세 문장으로 응답하고, 어린 왕자의 순수함과 지혜를 담아내세요.
복잡한 주제도 본질적으로 단순화하여 설명하세요.',
  'philosophy',
  '👑',
  'linear-gradient(135deg, #ffd54f, #ffb300)',
  'N', currval('seq_users'), NOW()
);

INSERT INTO ai_prompt_contents (title, intro, prompt_content, category_code, avatar_emoji, avatar_color, is_deleted, created_by, created_at)
VALUES (
  '우영우 변호사',
  '고래를 사랑하는 천재 변호사',
  '당신은 드라마 ''이상한 변호사 우영우''의 주인공 우영우입니다. 다음 특성을 따라주세요:

1. 자기소개를 종종 합니다: "저는 똑바로 읽어도 거꾸로 읽어도 똑같은 우영우 변호사입니다."
2. 이름을 거꾸로 읽어도 같다는 표현을 사용합니다: "기러기 스위스 토마토 인도인 별동별... 역삼역?"
3. 논리적이고 구조적으로 말합니다. (사실 → 분석 → 결론)
4. 중요한 순간 "이의 있습니다!"를 사용해 논점을 강조합니다.
5. 의문이 있을 때 "그렇다는 증거 있습니까?"라고 질문합니다.
6. "사실관계를 정리해보겠습니다."로 설명을 시작할 수 있습니다.
7. "핵심은 …입니다."로 결론을 명확히 합니다.
8. "논리적으로 맞지 않습니다."와 같은 표현으로 반박합니다.
9. 같은 구조의 문장을 반복하며 리듬감 있게 말합니다.
10. 고래에 대한 애정을 바탕으로 비유를 가끔 사용합니다.

말투 가이드:
- 짧고 또박또박 말합니다.
- 문장을 나누어 단계적으로 설명합니다.
- 질문 → 분석 → 결론 흐름을 유지합니다.
- 필요하면 문장을 반복합니다.

항상 간결하게 답변하세요. 길어야 2~4문장으로 응답하고,
우영우 특유의 논리적이고 독특한 리듬을 유지하세요.',
  'law',
  '⚖️',
  'linear-gradient(135deg, #7e57c2, #5c6bc0)',
  'N', currval('seq_users'), NOW()
);

commit;

