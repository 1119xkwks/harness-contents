# PostgreSQL Database Rules

## 1. Naming Convention

### Table & Column Names
- **Format**: 소문자 snake_case
- **Example**:
  ```
  ✓ user_accounts
  ✓ order_items
  ✓ created_at
  ✗ UserAccounts
  ✗ createdAt
  ```

## 2. Primary Key (PK)

### Rule
- 모든 테이블은 SEQUENCE로 PK 값을 자동 생성
- **PK 컬럼명**: `[table_name]_seq` (e.g., `users_seq`, `orders_seq`)
- **SEQUENCE 이름**: `seq_[table_name]` (e.g., `seq_users`, `seq_orders`)

### Example
```sql
-- SEQUENCE 생성
CREATE SEQUENCE seq_users
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  CACHE 1;

-- Table 생성
CREATE TABLE users (
  users_seq BIGINT PRIMARY KEY DEFAULT nextval('seq_users'),
  ...
);
```

## 3. Naming Rules for Database Objects

| Object Type | Pattern | Example |
|-------------|---------|---------|
| **Sequence** | `seq_[table_name]` | `seq_users`, `seq_order_items` |
| **PK Column** | `[table_name]_seq` | `users_seq`, `order_items_seq` |
| **Primary Key Constraint** | `pk_[table_name]` | `pk_users`, `pk_order_items` |
| **Unique Constraint** | `uni_[table_name]` | `uni_users`, `uni_order_items` |
| **Index** | `idx_[table_name]` | `idx_users`, `idx_order_items` |

### Unique Constraint Example
```sql
ALTER TABLE users
  ADD CONSTRAINT uni_users UNIQUE (email);
```

### Index Example
```sql
CREATE INDEX idx_users ON users(email);
CREATE INDEX idx_orders ON orders(user_id, created_at);
```

## 4. Common Columns (모든 테이블에 필수)

모든 테이블의 끝에 다음 컬럼들을 포함해야 합니다:

```sql
is_deleted CHAR(1) DEFAULT 'N' NOT NULL,
deleted_at TIMESTAMP,
created_by INT NOT NULL,
created_at TIMESTAMP NOT NULL,
updated_by INT,
updated_at TIMESTAMP
```

| Column | Type | Default | Nullable | Description |
|--------|------|---------|----------|-------------|
| `is_deleted` | CHAR(1) | 'N' | NOT NULL | 삭제 여부 (Y/N) |
| `deleted_at` | TIMESTAMP | - | NULL | 삭제 일시 |
| `created_by` | INT | - | NOT NULL | 작성자 ID |
| `created_at` | TIMESTAMP | - | NOT NULL | 작성 일시 |
| `updated_by` | INT | - | NULL | 수정자 ID |
| `updated_at` | TIMESTAMP | - | NULL | 수정 일시 |

## 5. Foreign Key (FK)

### Rule
- **개발 단계에서는 FK constraint를 생성하지 않음**
- FK 컬럼은 `[referenced_table_name]_seq` 형식으로 정의 (PK 컬럼명과 일치)
- ERD와 명세서에는 관계를 표기하되, 실제 SQL에서는 constraint 미생성

### Rationale
- 개발 중 테이블 구조 변경, 마이그레이션, 테스트 데이터 작업 효율성 향상
- 프로덕션 배포 시 별도의 마이그레이션 스크립트로 FK 추가 가능

### Example
```sql
-- ✓ FK 컬럼 정의만 (constraint 없음)
CREATE TABLE orders (
  orders_seq BIGINT PRIMARY KEY DEFAULT nextval('seq_orders'),
  users_seq BIGINT NOT NULL,  -- FK 컬럼 정의 (users 테이블의 PK 참조)
  ...
);

-- ✗ FK constraint는 생성하지 않음 (주석으로만 표기)
-- FOREIGN KEY (users_seq) REFERENCES users(users_seq)
```

## 6. General Guidelines

- ✓ 모든 테이블에 `[table_name]_seq` PK 필수
- ✓ Foreign Key 컬럼은 `[referenced_table_name]_seq` 형식
- ✓ Boolean 컬럼은 `is_[description]` (e.g., `is_active`)
- ✓ 검색/조회가 빈번한 컬럼에 INDEX 생성
- ✓ String 컬럼에는 적절한 길이 제약 (e.g., `VARCHAR(255)`)
- ✓ 모든 테이블 끝에 공통 컬럼들 추가 (is_deleted, deleted_at, created_by, created_at, updated_by, updated_at)
- ✗ Reserved keywords는 컬럼명으로 사용 금지
- ✗ FK constraint는 개발 단계에서 생성 금지

## 7. Example: Users Table

```sql
-- SEQUENCE 생성
CREATE SEQUENCE seq_users
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  CACHE 1;

-- 테이블 생성
CREATE TABLE users (
  users_seq BIGINT PRIMARY KEY DEFAULT nextval('seq_users'),
  email VARCHAR(255) NOT NULL,
  username VARCHAR(100) NOT NULL,
  is_active BOOLEAN DEFAULT true NOT NULL,
  is_deleted CHAR(1) DEFAULT 'N' NOT NULL,
  deleted_at TIMESTAMP,
  created_by INT NOT NULL,
  created_at TIMESTAMP NOT NULL,
  updated_by INT,
  updated_at TIMESTAMP,
  CONSTRAINT pk_users PRIMARY KEY (users_seq),
  CONSTRAINT uni_users UNIQUE (email, username)
);

-- 인덱스 생성
CREATE INDEX idx_users ON users(email, username);
```

## 8. Example: Orders Table (with FK reference)

```sql
-- SEQUENCE 생성
CREATE SEQUENCE seq_orders;

-- 테이블 생성
CREATE TABLE orders (
  orders_seq BIGINT PRIMARY KEY DEFAULT nextval('seq_orders'),
  users_seq BIGINT NOT NULL,  -- FK reference (constraint는 생성하지 않음)
  order_number VARCHAR(50) NOT NULL,
  total_amount DECIMAL(10, 2) NOT NULL,
  is_completed BOOLEAN DEFAULT false NOT NULL,
  is_deleted CHAR(1) DEFAULT 'N' NOT NULL,
  deleted_at TIMESTAMP,
  created_by INT NOT NULL,
  created_at TIMESTAMP NOT NULL,
  updated_by INT,
  updated_at TIMESTAMP,
  CONSTRAINT pk_orders PRIMARY KEY (orders_seq),
  CONSTRAINT uni_orders UNIQUE (order_number)
  -- FK constraint는 프로덕션 배포 시 별도 마이그레이션으로 추가
  -- FOREIGN KEY (users_seq) REFERENCES users(users_seq)
);

-- 인덱스 생성
CREATE INDEX idx_orders ON orders(users_seq, created_at);
```
