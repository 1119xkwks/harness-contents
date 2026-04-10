# Database Tables Specification

## 1. users (사용자 테이블)

### Table Description
사용자 계정 및 인증 정보를 관리하는 테이블

### Columns

| Column | Type | Constraints | Default | Comment |
|--------|------|-------------|---------|---------|
| `users_seq` | BIGINT | PRIMARY KEY | nextval('seq_users') | 사용자 고유 식별자 |
| `id` | VARCHAR(50) | NOT NULL, UNIQUE | - | 회원 ID |
| `pw` | VARCHAR(100) | NOT NULL | - | 회원 비밀번호 |
| `name` | VARCHAR(50) | NOT NULL | - | 회원명 |
| `is_deleted` | CHAR(1) | NOT NULL | 'N' | 삭제 여부 (Y/N) |
| `deleted_at` | TIMESTAMP | NULL | - | 삭제 일시 |
| `created_by` | INT | NOT NULL | - | 작성자 ID |
| `created_at` | TIMESTAMP | NOT NULL | - | 작성 일시 |
| `updated_by` | INT | NULL | - | 수정자 ID |
| `updated_at` | TIMESTAMP | NULL | - | 수정 일시 |

### Constraints & Indexes

```sql
-- Primary Key Constraint
CONSTRAINT pk_users PRIMARY KEY (users_seq)

-- Unique Constraint
CONSTRAINT uni_users UNIQUE (id)

-- Indexes
CREATE INDEX idx_users ON users(id);
```

### DDL

```sql
CREATE SEQUENCE seq_users
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  CACHE 1;

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
  CONSTRAINT pk_users PRIMARY KEY (users_seq),
  CONSTRAINT uni_users UNIQUE (id)
);

CREATE INDEX idx_users ON users(id);
```

---

## 2. common_codes (공통코드 테이블)

### Table Description
시스템에서 사용하는 공통 코드 및 코드값을 관리하는 테이블. 그룹 코드와 상세 코드를 모두 관리 가능

### Columns

| Column | Type | Constraints | Default | Comment |
|--------|------|-------------|---------|---------|
| `common_codes_seq` | BIGINT | PRIMARY KEY | nextval('seq_common_codes') | 공통코드 고유 식별자 |
| `code_name` | VARCHAR(50) | NOT NULL | - | 코드 명 |
| `code_value` | VARCHAR(200) | NOT NULL | - | 코드 값 |
| `is_group_yn` | CHAR(1) | NOT NULL | - | 그룹코드 여부 (Y/N) |
| `order_seq` | INT | NOT NULL | 0 | 코드 순서 정렬 지정 |
| `is_deleted` | CHAR(1) | NOT NULL | 'N' | 삭제 여부 (Y/N) |
| `deleted_at` | TIMESTAMP | NULL | - | 삭제 일시 |
| `created_by` | INT | NOT NULL | - | 작성자 ID |
| `created_at` | TIMESTAMP | NOT NULL | - | 작성 일시 |
| `updated_by` | INT | NULL | - | 수정자 ID |
| `updated_at` | TIMESTAMP | NULL | - | 수정 일시 |

### Constraints & Indexes

```sql
-- Primary Key Constraint
CONSTRAINT pk_common_codes PRIMARY KEY (common_codes_seq)

-- Unique Constraint (code_name, code_value 조합)
CONSTRAINT uni_common_codes UNIQUE (code_name, code_value)

-- Indexes
CREATE INDEX idx_common_codes ON common_codes(code_name, code_value);
```

### DDL

```sql
CREATE SEQUENCE seq_common_codes
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  CACHE 1;

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
  CONSTRAINT pk_common_codes PRIMARY KEY (common_codes_seq),
  CONSTRAINT uni_common_codes UNIQUE (code_name, code_value)
);

CREATE INDEX idx_common_codes ON common_codes(code_name, code_value);
```

---

## Summary

| Table Name | Description | Rows | PK | SEQUENCE |
|------------|-------------|------|----|---------| 
| `users` | 사용자 테이블 | - | users_seq | seq_users |
| `common_codes` | 공통코드 테이블 | - | common_codes_seq | seq_common_codes |

