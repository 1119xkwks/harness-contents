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
-- 3. CONSTRAINTS VERIFICATION
-- ============================================================

-- Constraint 확인
SELECT constraint_name, constraint_type, table_name
FROM information_schema.table_constraints
WHERE table_name IN ('users', 'common_codes')
ORDER BY table_name, constraint_name;

-- ============================================================
-- 4. SEQUENCE VERIFICATION
-- ============================================================

-- SEQUENCE 확인
SELECT sequence_name, start_value, increment_by, cache_size
FROM information_schema.sequences
WHERE sequence_name IN ('seq_users', 'seq_common_codes')
ORDER BY sequence_name;

-- ============================================================
-- 5. TABLE & COLUMN COMMENTS VERIFICATION
-- ============================================================

-- 테이블 코멘트 확인
SELECT table_name, obj_description(('public.' || table_name)::regclass, 'pg_class') AS table_comment
FROM information_schema.tables
WHERE table_schema = 'public' AND table_name IN ('users', 'common_codes')
ORDER BY table_name;

-- 컬럼 코멘트 확인
SELECT table_name, column_name, col_description((table_name)::regclass, ordinal_position) AS column_comment
FROM information_schema.columns
WHERE table_schema = 'public' AND table_name IN ('users', 'common_codes')
ORDER BY table_name, ordinal_position;
